require_relative 'boot'
require 'rails'

require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
# require 'action_view/railtie'
require 'action_cable/engine'
# require 'sprockets/railtie'
# require 'rails/test_unit/railtie'

Bundler.require(*Rails.groups)

module Volt
  class Application < Rails::Application
    config.load_defaults 5.1
    config.autoload_paths += Dir["#{config.root}/lib", "#{config.root}/lib/**/"]
    config.api_only = true

    Time::DATE_FORMATS[:datetime] = '%d.%m.%Y %H:%M:%S'
    Time::DATE_FORMATS[:time] = '%H:%M:%S'
    Time::DATE_FORMATS[:date] = '%d.%m.%Y'

    Date::DATE_FORMATS[:date] = '%d.%m.%Y'
  end
end
