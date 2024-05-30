require 'test_helper'

class GenesControllerTest < ActionController::TestCase
  setup do
    @genes = create_list(:gene,100)
    @gene  = @genes.first
    @gene.sequence_variants << create_list(:sequence_variant,20)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:genes)
  end

  test "should show gene" do
    get :show, :id => @gene.to_param
    assert_response :success
  end

end
