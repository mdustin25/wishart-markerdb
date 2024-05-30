require 'test_helper'

class ConditionsControllerTest < ActionController::TestCase
  setup do 
    @condition = 100.times.map{create(:condition)}.first
    100.times{create(:concentration, :condition => @condition)}
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show, :id => @condition.to_param
    assert_response :success
  end

end
