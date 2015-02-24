class Users::ConfirmationsController < Devise::ConfirmationsController


  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  def create
    #render inline: @token_return_to.inspect
    resource_params[:token_registration_location] = @token_registration_location
    resource_params[:token_registration_event_id] = @token_registration_event_id
    #super

    # =========================================
    # -----------------------------------------
    # Copypasted from devise gem
    # -----------------------------------------
    # =========================================

    self.resource = resource_class.send_confirmation_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      #respond_with({}, location: after_resending_confirmation_instructions_path_for(resource_name))
      required_template = 'devise/confirmations/confirmed_successfully'

      if modal?
        html_source = render_to_string template: required_template
        data = {html: html_source }

        #render inline: "#{data.to_json}"
        redirect_to new_user_session_path(locale: I18n.locale), notice: "You have successfully confirmed your account."
      else
        #respond_to_on_destroy
        render template: required_template
      end
    else
      respond_with(resource)
    end
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    #super

    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?

    if resource.errors.empty?
      set_flash_message(:notice, :confirmed) if is_flashing_format?

      sign_in(resource_name, resource)
      required_template = "devise/confirmations/confirmed_successfully"
      #respond_with_navigational(resource){ redirect_to after_confirmation_path_for(resource_name, resource) }
      redirect_to root_path(locale: I18n.locale), notice: {
                                                    template: required_template,
                                                    layout: 'modal_layout',
                                                    locals: {active: true, registration_event_id: (@registration_event.id rescue nil)},
                                                    title: "Ви успішно залогінились",
                                                    message: "тепер ви можете підписатися на подію або відмовитись. також у вас є особистий кабінет, де ви можете переглянути улюблені події, ті, на які ви підписались, переглянути історію змін. Також ви можете відредагувати свої дані. Будемо вдячні за ваш відгук. Приємного користування"
                                                }
    else
      respond_with_navigational(resource.errors, status: :unprocessable_entity){ render :new }
    end
  end

  # protected

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  # def after_confirmation_path_for(resource_name, resource)
  #   super(resource_name, resource)
  # end

  protected

  # The path used after resending confirmation instructions.
  def after_resending_confirmation_instructions_path_for(resource_name)
    is_navigational_format? ? new_session_path(resource_name) : '/'
  end

  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    if signed_in?(resource_name)
      signed_in_root_path(resource)
    else
      new_session_path(resource_name)
    end
  end
end
