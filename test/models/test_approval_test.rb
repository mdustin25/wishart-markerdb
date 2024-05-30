require 'test_helper'

class TestApprovalTest < ActiveSupport::TestCase
  should have_and_belong_to_many(:lab_tests)
end

# == Schema Information
#
# Table name: test_approvals
#
#  id   :integer(4)      not null, primary key
#  name :string(255)
#

