class TestUse < ActiveRecord::Base
  belongs_to :lab_test
  belongs_to :condition
  belongs_to :biomarker_category
  validates_presence_of :lab_test, :condition
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

