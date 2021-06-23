require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TeaBot
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.time_zone = 'Ekaterinburg'
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Don't generate system test files.
    config.generators.system_tests = nil

    if Rails.env.production? || Rails.env.staging?
      config.redis_config = {
        url: ENV['REDIS_URL'],
        port: ENV['REDIS_PORT'],
        db: ENV['REDIS_DB'],
        password: ENV['REDIS_PASSWORD']
      }
      config.sidekiq_config = {
        url:      ENV['REDIS_URL'],
        port:     ENV['REDIS_PORT'],
        db:       ENV['REDIS_DB'],
        password: ENV['REDIS_PASSWORD'],
        network_timeout: 5
      }
    elsif Rails.env.test?
      config.redis_config = { host: 'redis' }
      config.sidekiq_config = {}
    else
      config.redis_config = {}
      config.sidekiq_config = {}
    end

    config.autoload_paths << Rails.root.join('lib')
    config.eager_load_paths << Rails.root.join('lib')
    config.telegram_updates_controller.session_store = :redis_store, {expires_in: 1.month}
  end
end
