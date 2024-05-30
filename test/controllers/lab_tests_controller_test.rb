require 'test_helper'

class LabTestsControllerTest < ActionController::TestCase
  setup do
    @lab_tests = create_list( :lab_test, 100 )
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lab_tests)
  end

  test "should show lab_test" do
    get :show, :id => @lab_tests.first.to_param
    assert_response :success
  end

end
