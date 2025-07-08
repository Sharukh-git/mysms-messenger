require_relative "boot"

require 'dotenv/load'
require "rails"
require "action_controller/railtie"
require "action_view/railtie"
require "action_mailer/railtie"
require "active_job/railtie"
require "action_cable/engine"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)


module Backend
  class Application < Rails::Application
    config.load_defaults 7.0

    config.api_only = true

    #session and cookie support for API-only mode
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore, key: '_mysms_session'

    config.generators do |g|
      g.orm :mongoid
      g.test_framework nil
    end
  end
end

