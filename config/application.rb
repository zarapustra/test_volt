require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Volt
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.autoload_paths += Dir["#{config.root}/lib", "#{config.root}/lib/**/"]
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    Time::DATE_FORMATS[:datetime] = '%d.%m.%Y %H:%M:%S'
    Time::DATE_FORMATS[:time] = '%H:%M:%S'
    Time::DATE_FORMATS[:date] = '%d.%m.%Y'

    Date::DATE_FORMATS[:date] = '%d.%m.%Y'
  end
end
