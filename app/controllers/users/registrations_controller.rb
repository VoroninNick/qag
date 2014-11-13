class Users::RegistrationsController < Devise::RegistrationsController
# before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]



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


    build_resource(sign_up_params)

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

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

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
end
