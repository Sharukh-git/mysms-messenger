require_relative "boot"

if ['development', 'test'].include?(ENV['RAILS_ENV'])
  require 'dotenv/load'
end

require "rails"
require "action_controller/railtie"
require "action_view/railtie"
require "action_mailer/railtie"
require "active_job/railtie"
require "action_cable/engine"
require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

module Backend
  class Application < Rails::Application
    config.load_defaults 7.0

    config.api_only = true

    # Session and cookie support for API-only mode
    config.middleware.use ActionDispatch::Cookies

    config.middleware.use ActionDispatch::Session::CookieStore, key: '_mysms_session',
      same_site: Rails.env.production? ? :none : :lax,
      secure: Rails.env.production?

    config.generators do |g|
      g.orm :mongoid
      g.test_framework nil
    end
  end
end
