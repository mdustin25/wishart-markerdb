class SequenceVariantMeasurement < ActiveRecord::Base
  # include Measurement

  # measurement_of :sequence_variant
  belongs_to :sequence_variant
  belongs_to :conditions
  belongs_to :quality, polymorphic: true,
      dependent: :destroy
end

# == Schema Information
#
# Table name: sequence_variant_measurements
#
#  id                    :integer(4)      not null, primary key
#  condition_id          :integer(4)
#  indication_type_id    :integer(4)
#  biomarker_category_id :integer(4)
#  indication_modifier   :string(255)
#  comment               :string(255)
#  sequence_variant_id   :integer(4)
#  created_at            :datetime
#  updated_at            :datetime
#

