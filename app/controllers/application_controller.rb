class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception

  include ActionView::Helpers::OutputSafetyHelper
  include ActionView::Helpers::AssetUrlHelper
  include ActionView::Helpers::TagHelper
  include Cms::Helpers::PagesHelper
  extend Cms::Helpers::PagesHelper::ClassMethods
  include Cms::Helpers::MetaDataHelper
  include Cms::Helpers::NavigationHelper
  include Cms::Helpers::ImageHelper

  include Cms::Helpers::ActionView::CacheHelper
  include Cms::Helpers::CacheNamingHelper
  include ApplicationHelper
  before_action :initialize_csrf_token
  before_action :validate_csrf_token, if: -> { !check_devise_controller && !admin_panel? }

  # rescue_from CanCan::AccessDenied do |exception|
  #   #redirect_to main_app.root_path, :alert => exception.message
  #   render_unauthorized
  # end

  reload_rails_admin_config

  before_action :set_admin_locale, if: :admin_panel?
  before_action :disable_page_banner


  def disable_page_banner
    c = controller_name
    a = action_name
    @disable_page_banner = (c.in?(["events", "articles"]) && a == "list") || (c == "feedbacks" && a == "index") || (c == "pages" && a == "students")
    @gray_page_header = @disable_page_banner
  end

  def admin_panel?
    admin = params[:controller].to_s.starts_with?("rails_admin")

    return admin
  end

  def set_admin_locale
    I18n.locale = :uk
  end

  helper_method :modal?

  def modal?
    @is_modal ||= params[:modal] == "true"
  end

  helper_method :ajax?

  def ajax?
    @is_ajax ||= params[:ajax] == "true" || params[:ajax] == true
  end

  helper_method :current_route_name, :current_route?

  def current_route_name
    params[:route_name].to_sym
  end

  def current_route?(route_name)
    r = current_route_name
    r ? r == route_name.to_sym : nil
  end


  before_action :set_default_locale

  def set_default_locale
    I18n.locale = I18n.default_locale
  end


  def set_locale
    params_locale = params[:locale]
    if params_locale
      params_locale = params_locale.to_sym
    end

    locale = params_locale

    if !I18n.available_locales.include?(params_locale)
      locale = :en
    end

    I18n.locale = locale
  end

  def render_not_found
    @render_footer = false
    render template: "errors/not_found.html.slim", status: 404, layout: "application", locals: { status: 404, message: "На жаль, даної сторінки не існує, можливо вона була видалена,<br/>або ви ввели невірну адресу." }
  end

  def render_unauthorized
    @render_footer = false
    render template: "errors/not_found.html.slim", status: 401, layout: "application", locals: { status: 401, message: "На жаль, ви не маєте прав на цю операцію." }
  end

  before_action :update_sanitized_params, if: :devise_controller?

  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:first_name, :last_name, :email, :password, :password_confirmation, :city, :company, :status, :description)}
  end

  before_action :check_devise_controller

  def check_devise_controller
    @is_devise ||=  params[:controller] != "users/event_subscriptions" && (params[:controller].scan(/\Adevise\//).any? || params[:controller].scan(/\Ausers\//).any?)
  end

  before_action :set_layout
  def set_layout
    unless params[:controller].scan(/^rails_admin/).length > 0 

      controller_name_parts = params[:controller].split('/')
        controller_name_parts.count.times do |i|
          
          name_parts = controller_name_parts[i].split('_')
          name_parts.count.times do |j|
            name_parts[j] = name_parts[j].capitalize
          end
          controller_name_parts[i] = name_parts.join('')
        end
        controller_name = controller_name_parts.join('::')
        controller_class_name = "#{controller_name}Controller"
        if Object.const_defined_recursively?(controller_class_name)
          controller_class =  Object.const_get(controller_class_name) 
        else
          controller_class = nil
        end

      if modal?
        if !controller_class.nil?
          controller_class.layout 'modal_layout'
        end

        @modal_id = "#{params[:controller].parameterize.underscore}-#{params[:action]}-#{@_request.method.downcase}"

      else
        if !controller_class.nil?
          controller_class.layout 'application'
        end
      end
    end
  end

  before_action :init_locale_links

  def init_locale_links
    @page_locale_links = {}
    I18n.available_locales.each {|locale| @page_locale_links[locale.to_sym] = url_for(locale: locale) }
  end

  # if params[:load_partial]
  #   self.class.layout 'modal_layout'
  # end

  before_action :init_load_partial_or_template

  def init_load_partial_or_template
    output_data = {}

    available_options= [:load_partial, :load_template]

    provided_options_count = 0
    available_options.each do |option|
      if params.include? option
        provided_options_count += 1
      end
    end

    if provided_options_count > 0

      if params[:load_partial]
        params_partial_path = params[:load_partial]
        params_partial_paths = params_partial_path.split(',')
        output_partials = []
        params_partial_paths.each do |partial_path|
          content = render_to_string layout: 'render_partial', template: 'async_renderer/index', locals: { partial_path: partial_path }

          data_to_output = { partial: content, partial_path: partial_path }
          output_partials.push data_to_output
        end

        output_data[:partials] = output_partials



      end

      if params[:load_template]
        params_template_path = params[:load_template]
        params_template_paths = params_template_path.split(',')
        output_templates = []

        params_template_paths.each do |template_path|
          content = render_to_string layout: 'render_partial', template: template_path

          if template_path.split('/').first == 'modal'

          end

          data_to_output = { source: content, template_path: template_path }
          output_partials.push data_to_output
        end

        output_data[:templates] = output_templates
      end

      json_source = output_data.to_json
      render inline: json_source
    else
      #render inline: @_request.method

    end
  end


  before_action :check_is_user_admin
  def check_is_user_admin
    if params[:controller].scan(/^rails_admin/).length > 0
      if user_signed_in? && !current_user.admin?
        render_unauthorized
      end
    end
  end

  # redirect user to home if he is not admin when he trying to go /admin/*
  def redirect_to_home_if_user_requests_admin
    if params[:controller].scan(/^rails_admin/).length > 0
      unless user_signed_in? && current_user.role == 'admin' 
        redirect_to "/#{I18n.locale}"
      end
    end
  end

  before_action :init_event_registration_token
  def init_event_registration_token
    if (params[:controller] == 'users/confirmations' || params[:controller] == 'users/registrations' ) && params[:action] == 'create'
      @token_registration_location = nil
      @token_registration_event_id = nil
      if params[:registration_location]
        @token_registration_location = params[:registration_location]
      else
        @token_registration_location
      end

      if params[:registration_event_id]
        @token_registration_event_id = params[:registration_event_id]
      end

      if !@token_return_to
        @token_return_to = '/'
      end
    end
  end

  before_action :init_registration_event
  def init_registration_event
    flash_notice = flash[:notice]
    if flash_notice && flash_notice['locals'] && flash_notice['locals']['registration_event_id']
      @registration_event = Event.where("id = #{flash_notice['locals']['registration_event_id']}").first
    end
  end

  # =====================================================
  # -----------------------------------------------------
  # helpers for events
  # -----------------------------------------------------
  # =====================================================

  helper_method :subscribed_on_event?

  def get_events_i_am_subscribed_on
    @events_i_am_subscribed_on ||= ActiveRecord::Base.connection.execute("select s.event_id as event_id from event_subscriptions s where s.user_id = #{current_user.id}")
    if @event_ids_i_am_subscribed_on.nil?
      @event_ids_i_am_subscribed_on = []
      if @event_ids_i_am_subscribed_on.count == 0 && @events_i_am_subscribed_on.count > 0
        @events_i_am_subscribed_on.each do |e|
          @event_ids_i_am_subscribed_on.push e['event_id']
        end
      end
    end
  end

  def subscribed_on_event?(event_id)
    event_id = event_id.to_i
    if user_signed_in?
      get_events_i_am_subscribed_on
      #return @events_i_am_subscribed_on.where("event_id = #{event_id}").count > 0
      return @event_ids_i_am_subscribed_on.index(event_id) != nil
    else
      return nil
    end
  end

  helper_method :subscribed_event_ids_from_range_for_user

  # def subscribed_event_ids_from_range_for_user(user_id,event_ids)
  #   event_ids_string = event_ids
  #   event_ids_array = event_ids.split(',')
  #   if user_signed_in?
  #
  #     @events_i_am_subscribed_on ||= ActiveRecord::Base.connection.execute("select s.event_id as event_id from event_subscriptions s where s.user_id = #{current_user.id}")
  #     @event_ids_i_am_subscribed_on ||= []
  #     if @event_ids_i_am_subscribed_on.count == 0 && @events_i_am_subscribed_on.count > 0
  #       @events_i_am_subscribed_on.each do |e|
  #         @event_ids_i_am_subscribed_on.push e['event_id']
  #       end
  #     end
  #     #return @events_i_am_subscribed_on.where("event_id = #{event_id}").count > 0
  #     result = @event_ids_i_am_subscribed_on.select {|num| event_ids_array.include?(num)  }
  #
  #     #return @event_ids_i_am_subscribed_on.index(event_id) != nil
  #     return result
  #   else
  #     return nil
  #   end
  # end

  helper_method :subscribed_event_ids_from_range
  def subscribed_event_ids_from_range(event_ids)
    if user_signed_in?
      User.subscribed_event_ids_from_range_for_user(current_user.id, event_ids)
    else
      nil
    end
  end

  def subscribed_event_ids_from_range_for_user(user_id, event_ids)
    #if user_signed_in?
      #return subscribed_event_ids_from_range_for_user(current_user.id, event_ids)
      return User.subscribed_event_ids_from_range_for_user(user_id, event_ids)
    #else
    #  return nil
    #end
  end

  #helper_method :host_name

  def generate_csrf_token
    str = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890".split("")
    token = 256.times.map{ str.sample }.join("")
  end

  def initialize_csrf_token
    if request.post?
      #return render inline: "<div>#{get_csrf_token.inspect}</div><div>#{user_sent_token.inspect}</div><div>valid: #{valid_csrf_token?.inspect}</div>"
    end

    session["_csrf_token"] = generate_csrf_token if get_csrf_token.blank?
  end

  def get_csrf_token
    session["_csrf_token"]
  end

  def render_csrf_token
    if request.referrer
      render inline: get_csrf_token
    else
      render inline: "bot detected", status: 403
    end

  end

  def user_sent_token
    request.headers["X-CSRFToken"]
  end

  def valid_csrf_token?
    get_csrf_token == user_sent_token
  end

  # before_action do
  #   render inline: "devise: #{@is_devise.inspect}; admin: #{admin_panel?}"
  # end

  def allowed_without_csrf?
    (controller_name == "events" && action_name.in?(["enable_event_subscription", "archive_event_subscription"])) || @is_devise
  end

  def validate_csrf_token
    if !request.get?
      if allowed_without_csrf?
        return
      end

      if !valid_csrf_token?
        render inline: "Invalid authenticity token", status: 403
      end
    end
  end

  before_action :_set_page_banner_title
  def _set_page_banner_title
    @_page_banner_title = I18n.t("layout.breadcrumbs.#{params[:route_name]}", raise: true) rescue nil
  end

  def short_user_info
    u = current_user
    if u
      get_events_i_am_subscribed_on
      event_ids_i_am_subscribed_on = @event_ids_i_am_subscribed_on
      render json: { email: u.email, event_ids_i_am_subscribed_on: event_ids_i_am_subscribed_on }
    else
      render json: {}, status: 401
    end

  end

  def alias_or_not_found
    url = params[:url] || URI(request.url).path.gsub(/\A\//, "")
    a = PageAlias.where(url: url).first
    if !a
      PageAlias.create(url: url)
    else
      redirect_url = a.redirect_url
      redirect_url = a.page.url rescue false if redirect_url.blank?


      if redirect_url.present?
        return redirect_to redirect_url, status: 301
      end
    end

    return render_not_found
  end
end
