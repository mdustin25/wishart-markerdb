require 'test_helper'

class ConditionCategoryTest < ActiveSupport::TestCase
  should have_and_belong_to_many(:conditions) 
end

# == Schema Information
#
# Table name: condition_categories
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

