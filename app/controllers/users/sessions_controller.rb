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
    if modal?
      html_source = render_to_string template: 'devise/sessions/signed_in_successfully_message.html'
      data = { html: html_source }
      render inline: "#{data.to_json}"
    else
      #respond_with resource, location: after_sign_in_path_for(resource)
      render template: "devise/sessions/signed_in_successfully_message.html"
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message :notice, :signed_out if signed_out && is_flashing_format?
    yield if block_given?
    if modal?
      html_source = render_to_string template: 'devise/sessions/signed_out_successfully_message.html'
      data = { html: html_source }
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
