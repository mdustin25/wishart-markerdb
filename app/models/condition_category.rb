# == Schema Information
# Schema version: 20110503230020
#
# Table name: condition_categories
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class ConditionCategory < ActiveRecord::Base
  has_and_belongs_to_many :conditions
end
