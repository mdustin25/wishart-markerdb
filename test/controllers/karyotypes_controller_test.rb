require 'test_helper'

class KaryotypesControllerTest < ActionController::TestCase
  setup do
    @karyotypes = create_list(:karyotype,3)
    @karyotype = @karyotypes.first
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show, id: @karyotype.to_param
    assert_response :success
  end

end
