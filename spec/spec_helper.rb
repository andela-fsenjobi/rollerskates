require 'coveralls'
Coveralls.wear!

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "todolist/config/application"
require "rspec"
require "capybara"

RSpec.shared_context type: :feature do
  require "capybara/rspec"
  before(:all) do
    app = Rack::Builder.
          parse_file(File.join(__dir__, "todolist", "config.ru")).first
    Capybara.app = app
  end
end

ENV["RACK_ENV"] = "test"
