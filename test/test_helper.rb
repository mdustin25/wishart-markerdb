ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require 'factory_girl'
require 'minitest/unit'
require 'mocha/mini_test'

# To add Capybara feature tests add `gem "minitest-rails-capybara"`
# to the test group in the Gemfile and uncomment the following:
# require "minitest/rails/capybara"

# Load the test set modules
Dir.glob(Rails.root.join 'test/test_modules/*').each do |file|
  require file
end


class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!
  include FactoryGirl::Syntax::Methods

  # Add more helper methods to be used by all tests here...
end

# methods to include in functional tests
class  ActionController::TestCase
  include Devise::TestHelpers

  # NOTE to test signing with devise put something like 
  # the following into the test:
  #   @request.env["devise.mapping"] = Devise.mappings[:user]
  #   sign_in FactoryGirl.create(:user)
end
