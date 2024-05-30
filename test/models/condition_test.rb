require 'test_helper'

class ConditionTest < ActiveSupport::TestCase
  include ActsAsAliasableTest
  include ActsAsLinkableTest
  include ActsAsCitationOwnerTest

  should have_and_belong_to_many(:categories)
  should have_db_column(:name).of_type(:string)
  should have_db_column(:description).of_type(:text)
  should have_db_column(:organism).of_type(:string)
  should have_db_column(:review_date).of_type(:date)

  should "return a hash of all measurements" do
    condition = create(:condition)
    result = create_list(:concentration, 3, :condition => condition)
    assert_equal result, condition.all_measurements[:concentrations]
  end
end
