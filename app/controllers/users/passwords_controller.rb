class Users::PasswordsController < Devise::PasswordsController
  skip_before_filter :require_no_authentication, only: [:edit_password, :update_password]
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  # def create
  #   super
  # end



  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      #respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
      if modal?
        html_source = render_to_string template: 'devise/passwords/sent_successfully'
        data = { html: html_source }
        render inline: "#{data.to_json}"

      else

        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      respond_with(resource)
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end

  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      set_flash_message(:notice, flash_message) if is_flashing_format?
      sign_in(resource_name, resource)
      if modal?
        html_source = render_to_string template: 'devise/sessions/signed_in_successfully_message.html'
        data = { html: html_source }
        render inline: "#{data.to_json}"
      else
        #respond_with resource, location: after_resetting_password_path_for(resource)
        render template: "devise/sessions/signed_in_successfully_message.html"
      end
    else
      respond_with resource
    end
  end

  def edit_password
    if ajax?
      response_object = {}

      if user_signed_in?
        @breadcrumbs = {
            home: {},
            dashboard: {
                title: "Особистий кабінет",
                link: {
                    url: edit_user_registration_path(locale: locale)
                }
            },
            change_password: {
                title: "Змінити пароль",
                link: {
                    url: my_edit_user_password_path(locale: I18n.locale)
                }
            }
        }


        @user = current_user
        #if ajax?
          ajax_response = {}

        #end
        # render
        response_object[:html] = render_to_string(template: 'devise/passwords/_custom_edit_form2', layout: false)
      else
        response_object[:result] = 'unregistered'

      end

      render inline: response_object.to_json

    else
      if user_signed_in?
        # render
      else
        redirect_to new_user_session_path(locale: I18n.locale)
      end
    end
  end

  def update_password
    if user_signed_in?
      required_template = "devise/passwords/edit_password"
      @breadcrumbs = {
          home: {},
          dashboard: {
              title: "Особистий кабінет",
              link: {
                  url: edit_user_registration_path(locale: locale)
              }
          },
          change_password: {
              title: "Змінити пароль",
              link: {
                  url: my_edit_user_password_path(locale: I18n.locale)
              }
          }
      }

      @user = current_user

      current_password = params[:user][:current_password]
      new_password = params[:user][:password]
      new_password_confirmation = params[:user][:password_confirmation]

      @saved = false
      if @user.valid_password?(current_password) && current_password != new_password  && new_password == new_password_confirmation && new_password.length >= 8
        @user.password = new_password
        @saved = @user.save
      end


      render template: "devise/passwords/edit_password" unless @saved
      redirect_to new_user_session_path(locale: I18n.locale) if @saved

      #render template: required_template
    else
      redirect_to new_user_session_path(locale: I18n.locale)
    end
  end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
