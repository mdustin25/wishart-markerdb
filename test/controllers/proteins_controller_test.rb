require 'test_helper'

class ProteinsControllerTest < ActionController::TestCase
  setup do
    @proteins = create_list(:protein,3)
    @protein = @proteins.first
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:proteins)
  end

  test "should show protein" do
    get :show, :id => @protein.to_param
    assert_response :success
  end
end
