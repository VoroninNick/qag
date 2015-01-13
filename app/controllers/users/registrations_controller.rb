class Users::RegistrationsController < Devise::RegistrationsController
# before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]

  #before_filter :configure_permitted_parameters





  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   #if verify_recaptcha
  #   if params[:modal] == 'true'
  #     if User.where(email: params[:user][:email]).count == 0
  #       super
  #     else
  #       respond_to do |format|
  #         format.html do
  #           render inline: "email_already_taken"
  #         end
  #       end
  #     end
  #   else
  #     super
  #   end
  #   #else
  #   #  build_resource(sign_up_params)
  #   #  clean_up_passwords(resource)
  #   #  flash.now[:alert] = "There was an error with the recaptcha code below. Please re-enter the code."
  #   #  flash.delete :recaptcha_error
  #   #  render :new
  #   #end
  # end

  def create

    params.permit("user[contact_phone]")

    build_resource(sign_up_params)




    if resource.respond_to?(:registration_event_id)
      resource.registration_event_id = params[:registration_event_id]
    end

    if resource.respond_to?(:registration_location)
      resource.registration_location = params[:registration_location]
    end

    #if resource.respond_to?("contact_phone=")
    #  resource.send("contact_phone=", params[:user][:contact_phone])
    #end

    resource_saved = resource.save
    yield resource if block_given?
    if resource_saved
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        if modal?
          respond_to do |format|
            format.html do
              render inline: "signed_in_successfully"
            end
          end
        else
          respond_with resource, location: after_sign_up_path_for(resource)
        end
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        if modal?
          html_source = render_to_string template: 'devise/registrations/signed_up_successfully'
          data = { html: html_source }
          render inline: "#{data.to_json}"

        else

          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      end
    else
      clean_up_passwords resource
      @validatable = devise_mapping.validatable?
      if @validatable
        @minimum_password_length = resource_class.password_length.min
      end

      if modal?
        respond_to do |format|

          format.json do
            response_source = { errors: resource.errors }
            #render inline: "cannot_create_user"
            render inline: "#{response_source.to_json}"
          end
        end
      else
        respond_with resource
      end
    end
  end

  def generate_dashboard_data
    @breadcrumbs = {
        home: {},
        dashboard: {
            title: "Особистий кабінет",
            link: {
                url: edit_user_registration_path(locale: locale)
            }
        }
    }
  end

  # GET /resource/edit
  def edit
    generate_dashboard_data

    super


  end

  def update_attribute
    rendered = false
    if user_signed_in?
      u = current_user
      params_attribute_name = params[:attribute]
      canSet = u.respond_to?("#{params_attribute_name}=")
      params_value = params[:value]
      if canSet && params_value
        u.send("#{params_attribute_name}=", params_value)
        saved = u.save
        if saved
          rendered = true
          render inline: { saved: true }.to_json
        else
          if !rendered
            rendered = true
            render inline: { error: 'not_saved' }
          end
        end
      end
    end
    render inline: { error: 'unregistered' } if !rendered
  end

  # PUT /resource
  def update
    params.permit(:contact_phone)
    generate_dashboard_data
    devise_parameter_sanitizer.for(:account_update).push(:first_name, :last_name, :contact_phone, :city, :company, :status)

    #permit :first_name, :last_name, :contact_phone, :city, :company, :status

    super
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # You can put the params you want to permit in the empty array.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.for(:sign_up) << :attribute
  # end

  # You can put the params you want to permit in the empty array.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.for(:account_update) << :attribute
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  def configure_permitted_parameters
    #devise_parameter_sanitizer.for(:sign_up).push(:first_name, :last_name, :contact_phone, :city, :company, :status)
    #devise_parameter_sanitizer.push(:first_name, :last_name, :contact_phone, :city, :company, :status)

  end
end
