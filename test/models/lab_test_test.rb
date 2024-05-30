require 'test_helper'

class LabTestTest < ActiveSupport::TestCase
  include ActsAsAliasableTest
  include ActsAsLinkableTest
  include ActsAsCitationOwnerTest

  should have_db_column(:name).of_type(:string)
  should have_db_column(:formal_name).of_type(:string)
  should have_db_column(:description).of_type(:text)
  should have_db_column(:lab_test_online_name).of_type(:string)
  should have_db_column(:fda_search_term).of_type(:string)
  should have_db_column(:review_date).of_type(:date)

  should have_many(:test_uses)
  should have_and_belong_to_many(:biofluids)
  should have_and_belong_to_many(:test_approvals)
  should have_many(:fda_kits)

  should_eventually "return fda link" do
  end

  should "return a lab test online link" do
    lab_test = LabTest.new :lab_test_online_name => "test_name"
    link_type = LinkType.new(:name => "Lab Test Online", :prefix => "testurl.com/")
    LinkType.expects(:find_by_name).
      with("lab_test_online_metabolite").
      returns(link_type)
    assert_equal "testurl.com/test_name",
      lab_test.lab_test_online_link.url
  end

end
