ENV['RAILS_ENV'] ||= 'test'
if ENV['TRAVIS']
  require 'coveralls'
  Coveralls.wear!('rails')
end
require File.expand_path('../../config/environment', __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'
require 'spec_helper'
require 'capybara/rails'
require 'capybara/rspec'
require 'selenium/webdriver'
require 'capybara-screenshot/rspec'

I18n.default_locale = :en

include Warden::Test::Helpers
Warden.test_mode!

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.after do
    Warden.test_reset!
  end
end

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w(headless no-sandbox window-size=1200,600) }
  )

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    desired_capabilities: capabilities
  )
end

Capybara::Screenshot.register_driver(:headless_chrome) do |driver, path|
  driver.browser.save_screenshot(path)
end

Capybara.asset_host = 'http://localhost:3000'
Capybara::Screenshot.prune_strategy = :keep_last_run
Capybara.javascript_driver = :headless_chrome
Capybara.default_max_wait_time = 60

Capybara.exact = true

OmniAuth.config.test_mode = true
