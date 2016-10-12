require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Qag
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de


    Bundler.require(:default, Rails.env)

    config.i18n.default_locale = :ru
    config.i18n.available_locales = [:uk, :ru, :en]

    config.assets.precompile += %w( modernizr_load1.js modernizr_svg.min.js )

    Rails.application.config.assets.precompile += %w( with_full_page.js with_full_page.css )

    config.action_mailer.default_url_options = {
        :host => 'qagroup.com.ua',
    }

    config.assets.precompile += %w(ckeditor/lang/*.js ckeditor/plugins/**/*.js ckeditor/plugins/**/*.css)

    if Rails.env != :production
     #config.assets.compile = false
    end
  end
end


