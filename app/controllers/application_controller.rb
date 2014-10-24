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
      params_partial_paths = params_partial_path.split(',')
      output_partials = []
      params_partial_paths.each do |partial_path|
        content = render_to_string layout: 'render_partial', template: 'async_renderer/index', locals: { partial_path: partial_path }

        data_to_output = { partial: content, partial_path: partial_path }
        output_partials.push data_to_output
      end

      json_source = output_partials.to_json

      render inline: json_source
    end
  end
end
