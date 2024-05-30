require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  setup do
    # Need to have more categories than the step size
    create_list(:condition_category,15)
  end

  test "should get main" do
    get :main
    assert_response :success
  end

  test "should get about" do
    get :about
    assert_response :success
  end

  test "should get contact" do
    get :contact
    assert_response :success
  end

  test "should get downloads" do
    get :downloads
    assert_response :success
  end

end
