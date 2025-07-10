require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = false

  # Use environment variable to enable public file server (needed for Render)
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?

  config.log_level = :info
  config.log_tags = [ :request_id ]

  config.action_mailer.perform_caching = false
  config.i18n.fallbacks = true
  config.active_support.report_deprecations = false
  config.log_formatter = ::Logger::Formatter.new

  # Logging to STDOUT (required by platforms like Render)
  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end

  # Disable dumping schema since we're using Mongoid, not ActiveRecord
  # This line was causing the crash and is removed:
  # config.active_record.dump_schema_after_migration = false

  # Allow all hosts
  config.hosts.clear
end
