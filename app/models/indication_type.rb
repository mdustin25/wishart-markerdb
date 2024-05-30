# This class is to identify what a measurement
# indicates about a condition, and what category
# the biomarker falls into (Diagnostic, Prognostic, etc.)
class IndicationType < ActiveRecord::Base
  belongs_to :biomarker_category
  # TODO add method to get all measurements by
  # indication type
  def name
    indication
  end
end

# == Schema Information
# Schema version: 20110705012520
#
# Table name: indication_types
#
#  id                    :integer(4)      not null, primary key
#  biomarker_category_id :integer(4)
#  indication            :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#
