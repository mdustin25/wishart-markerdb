# == Schema Information
# Schema version: 20110527215044
#
# Table name: test_approvals
#
#  id   :integer(4)      not null, primary key
#  name :string(255)
#

class TestApproval < ActiveRecord::Base
  has_and_belongs_to_many :lab_tests
end
