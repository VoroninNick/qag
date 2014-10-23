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

  before_filter do
    if params[:load_partial]
      params_partial_path = params[:load_partial]
      content = render_to_string layout: 'render_partial', template: 'async_renderer/index', locals: {  }
      data_to_output = { partial: content, partial_path: params_partial_path }
      json_source = data_to_output.to_json

      render inline: json_source
    end
  end
end
