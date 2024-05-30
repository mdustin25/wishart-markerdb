require 'test_helper'

class LabTestOwnershipTest < ActiveSupport::TestCase
  setup do
    @ownership = create(:lab_test_ownership) 
  end

  should belong_to(:lab_test_owner)
  should belong_to(:lab_test)

  should "have shortcut for owner" do
    assert_equal @ownership.lab_test_owner, @ownership.owner
  end
end
