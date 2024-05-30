require 'test_helper'

class BiofluidTest < ActiveSupport::TestCase
  #include ActsAsLabTestOwnerTest

  should have_and_belong_to_many :lab_tests
  should have_db_column(:name).of_type(:string)
end

# == Schema Information
#
# Table name: biofluids
#
#  id   :integer(4)      not null, primary key
#  name :string(255)
#

