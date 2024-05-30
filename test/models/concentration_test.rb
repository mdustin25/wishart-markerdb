require 'test_helper'

class ConcentrationTest < ActiveSupport::TestCase
  include ActsAsMeasurementTest

  should belong_to(:solute)

  [ :age_range,
    :level,
    :location_name,
    :sex,
    :biofluid,
    :comment
  ].each do |attr|
    should have_db_column(attr).of_type(:string)
  end

  should have_db_column(:special_constraints).of_type(:text)
end


# == Schema Information
#
# Table name: concentrations
#
#  id                    :integer(4)      not null, primary key
#  age_range             :string(255)
#  level                 :string(255)
#  location_name         :string(255)
#  special_constraints   :text
#  sex                   :string(255)
#  biofluid              :string(255)
#  comment               :string(255)
#  range                 :string(255)
#  high                  :float
#  low                   :float
#  mean                  :float
#  units                 :string(255)
#  pvalue                :float
#  created_at            :datetime
#  updated_at            :datetime
#  solute_type           :string(255)
#  solute_id             :integer(4)
#  condition_id          :integer(4)
#  indication_type_id    :integer(4)
#  biomarker_category_id :integer(4)
#  indication_modifier   :string(255)
#

