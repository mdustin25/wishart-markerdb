require 'test_helper'

class BiomarkerCategoryMembershipTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: biomarker_category_memberships
#
#  id                    :integer(4)      not null, primary key
#  biomarker_id          :integer(4)
#  biomarker_type        :string(255)
#  biomarker_category_id :integer(4)
#

