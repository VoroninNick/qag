class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout 'application_foundation'

  before_filter do
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

  before_filter :update_sanitized_params, if: :devise_controller?

  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:first_name, :last_name, :email, :password, :password_confirmation, :city, :company, :status, :description)}
  end

  before_filter do
    @is_devise = params[:controller].scan(/^devise\//).count > 0
  end

  before_filter do
    #str = render_to_string controller: 'home', action: 'index'

    #if params[:async]
      #self.class.layout ''
    #end

    #output = render_to_string
    #render inline: output

    #self.class.layout

    # params_controller = 'home'
    # params_action = 'index'
    #
    # controller_class_name = "#{params_controller.capitalize}Controller"
    # controller_class = nil
    # if Object.const_defined?(controller_class_name)
    #   controller_class = Object.const_get(controller_class_name)
    #
    #   controller_instance = controller_class.new
    #   if controller_instance.respond_to?(params_action)
    #     controller_instance.send(params_action)
    #   end
    # end



    #render inline: self.controller.send(:_layout).virtual_path.name

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
        #render inline: controller_class_name
        if Object.const_defined_recursively?.const_defined?(controller_class_name)
          controller_class =  Object.const_get(controller_class_name) 
        else
          controller_class = nil
        end

      if params[:modal] == 'true'
        #render inline: params.inspect
        #self.class.layout 'modal-layout'
        #params[:controller] = 'devise/aPP/home_page_index'

        
        #render inline: controller_class_name
        if !controller_class.nil?
          #render inline: 'hello'
          controller_class.layout 'modal-layout'
        end
        #render layout: 'modal-layout'
        #render inline: params.inspect
        @modal_id = "#{params[:controller].parameterize.underscore}-#{params[:action]}-#{@_request.method.downcase}"

      else
        if !controller_class.nil?
          #render inline: 'hello'
          controller_class.layout 'application_foundation'
        end
      end
    end
  end

  before_filter do
    @page_locale_links = {}
    I18n.available_locales.each {|locale| @page_locale_links[locale.to_sym] = url_for(locale: locale) }
  end

  # if params[:load_partial]
  #   self.class.layout 'modal-layout'
  # end

  before_filter do
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


  before_filter do
    if params[:controller].scan(/^rails_admin/).length > 0
      unless user_signed_in? && current_user.role == 'admin' 
        redirect_to "/#{I18n.locale}"
      end
    end
  end

end
