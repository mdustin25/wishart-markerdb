require 'test_helper'

class ChemicalsControllerTest < ActionController::TestCase
  setup do
    @chemicals = 3.times.map{create(:chemical)}
    @chemical = @chemicals.first
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should show chemical" do
    get :show, :id => @chemical.to_param
    assert_response :success
  end

end
