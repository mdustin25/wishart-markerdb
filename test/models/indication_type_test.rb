require 'test_helper'

class IndicationTypeTest < ActiveSupport::TestCase
  should belong_to :biomarker_category
  should have_db_column(:indication).of_type(:string)
end

# == Schema Information
#
# Table name: indication_types
#
#  id                    :integer(4)      not null, primary key
#  biomarker_category_id :integer(4)
#  indication            :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#

