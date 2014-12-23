class Users::SessionsController < Devise::SessionsController
# before_filter :configure_sign_in_params, only: [:create]

  prepend_before_filter :verify_user, only: [:destroy]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_flashing_format?
    sign_in(resource_name, resource)
    yield resource if block_given?

    required_template = "devise/sessions/signed_in_successfully_message.html"

    params_registration_location = params[:registration_location]
    params_registration_event_id = params[:registration_event_id]

    #redirect_to_location = params_registration_location

    #if !redirect_to_location
    #  redirect_to_location = '/'
    #end

    @event = nil

    if params_registration_event_id
      matched_events = Event.where(id: params_registration_event_id.to_i)
      if matched_events.count > 0
        @event = matched_events.first

        required_template = "devise/event_subscriptions/new"
      end
    end

    if current_user.sign_in_count == 1

      @registration_location = current_user.registration_location
      @registration_event = current_user.registration_event
    end
    #render inline: "hello"


    if modal?
      html_source = render_to_string template: required_template
      data = { html: html_source }



      params_loaded_events = params[:loaded_events]
      loaded_event_ids = []
      loaded_event_ids_string = ""
      if params_loaded_events
        #loaded_event_ids = params_loaded_events.split(',')
        loaded_event_ids_string = params_loaded_events
        event_ids_i_am_subscribed_on = subscribed_event_ids_from_range(loaded_event_ids_string)
        #ActiveRecord::Base.connection.execute("select id from events where id in(#{loaded_event_ids_string})")
        data[:event_ids_i_am_subscribed_on] = event_ids_i_am_subscribed_on
        data[:events_i_am_subscribed_on] = []
        event_ids_i_am_subscribed_on.each do |event_id|
          event_data = { :"event_id" => event_id, :decline_button_link => event_unsubscription_form_path(event_id: event_id, locale: I18n.locale) }
          data[:events_i_am_subscribed_on].push event_data
        end

        data[:decline_button_text] = t("layout.buttons.unregister")
      end

      render inline: "#{data.to_json}"
    else
      #respond_with resource, location: after_sign_in_path_for(resource)

      #render inline:
      redirect_location = after_sign_in_path_for(current_user) || current_user.registration_location
      if !redirect_location
        redirect_location = root_path(locale: I18n.locale)
      end


      local_notice = {}

      if redirect_location.scan(/^\/admin/)
        local_notice = "Ви увійшли в систему."
      else
        local_notice[:template] = required_template
        local_notice[:layout] = 'modal_layout'
        local_notice[:locals] = {active: true, registration_event_id: (@registration_event.id rescue nil)}
        local_notice[:title] = "Ви успішно залогінились"
        local_notice[:message] = "тепер ви можете підписатися на подію або відмовитись. також у вас є особистий кабінет, де ви можете переглянути улюблені події, ті, на які ви підписались, переглянути історію змін. Також ви можете відредагувати свої дані. Будемо вдячні за ваш відгук. Приємного користування"
      end

      redirect_to redirect_location, notice: local_notice
      #render template: required_template
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  def destroy
    if user_signed_in?
      user_id = current_user.id
    end
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message :notice, :signed_out if signed_out && is_flashing_format?
    yield if block_given?
    if modal?
      html_source = render_to_string template: 'devise/sessions/signed_out_successfully_message.html'
      data = { html: html_source }

      params_loaded_events = params[:loaded_events]

      if params_loaded_events

        loaded_event_ids_string = params_loaded_events
        event_ids_i_am_subscribed_on = subscribed_event_ids_from_range_for_user(user_id, loaded_event_ids_string)

        data[:event_ids_i_am_subscribed_on] = event_ids_i_am_subscribed_on
        data[:events_i_am_subscribed_on] = []
        event_ids_i_am_subscribed_on.each do |event_id|
          event_data = { :"event_id" => event_id, :subscribe_button_link => event_unsubscription_form_path(event_id: event_id, locale: I18n.locale) }
          data[:events_i_am_subscribed_on].push event_data
        end

        data[:subscribe_button_text] = t("layout.buttons.register")
      end

      render inline: "#{data.to_json}"
    else
      #respond_to_on_destroy
      render template: "devise/sessions/signed_out_successfully_message.html"
    end

  end

  def destroy_form
  end

  # protected

  # You can put the params you want to permit in the empty array.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end

  private

  def verify_user
    ## redirect to appropriate path
    if !user_signed_in?
      #redirect_to new_user_session_path, notice: 'You have already signed out. Please sign in again.' and return unless user_signed_in?
    end
  end

  def verify_signed_out_user
    if params[:modal] != 'true'
      super
    end
  end
end
