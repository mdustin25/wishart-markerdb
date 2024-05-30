require 'test_helper'

class TestUseTest < ActiveSupport::TestCase
  should have_db_column(:description).of_type(:string)
  should have_db_column(:biomarker_class_name).of_type(:string)
  should belong_to(:lab_test)
  should belong_to(:condition)
  should belong_to(:biomarker_category)
  should validate_presence_of(:condition)
  should validate_presence_of(:lab_test)
end


# == Schema Information
#
# Table name: test_uses
#
#  id                    :integer(4)      not null, primary key
#  description           :string(255)
#  lab_test_id           :integer(4)
#  condition_id          :integer(4)
#  biomarker_category_id :integer(4)
#  biomarker_class_name  :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#

