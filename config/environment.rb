RAILS_GEM_VERSION = '2.3.3' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.time_zone = 'UTC'

  config.gem 'guid'
  config.gem 'gravatar'
end

ActionMailer::Base.smtp_settings = YAML::load(File.read(File.join(Rails.root, 'config', 'action_mailer.yml')))