require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Vcms
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Etc/UTC'
    config.time_zone = 'Hanoi'
    # config.active_record.default_timezone = :utc
    config.active_record.default_timezone = :local

    #  Load all file module
    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += %W(#{config.root}/lib/dtos)
    config.autoload_paths += %W(#{config.root}/lib/http)
    config.autoload_paths += %W(#{config.root}/lib/log)
    config.autoload_paths += %W(#{config.root}/lib/redis_cache)

    # Config mailer
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.default_url_options = { host: ENV["APP_DOMAIN"] }

    # SMTP settings for gmail
    config.action_mailer.smtp_settings = {
        :address              => ENV["MAIL_SMTP_ADDRESS"],
        :port                 => ENV["MAIL_SMTP_PORT"],
        :domain               => ENV["MAIL_SMTP_DOMAIN"],
        :user_name            => ENV["MAIL_SMTP_USER_NAME"],
        :password             => ENV["MAIL_SMTP_PASSWORD"],
        :authentication       => ENV["MAIL_SMTP_AUTHENTICATION"],
        :enable_starttls_auto => true
    }
    config.action_mailer.default_options = {
        from: ENV["MAIL_SMTP_USER_NAME"]
    }
    config.action_mailer.perform_deliveries = true
    config.action_mailer.raise_delivery_errors = true
  end
end
