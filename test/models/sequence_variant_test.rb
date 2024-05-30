require 'test_helper'

class SequenceVariantTest < ActiveSupport::TestCase
  include ActsAsBiomarkerTest

  should belong_to(:gene)
  should have_many(:sequence_variant_measurements)

  [ :description,
    :position,
    :variation,
    :gene_symbol,
    :reference_sequence
  ].each do |attr|
    should have_db_column(attr).of_type(:string)
  end

  should have_db_column(:coding).of_type(:boolean)
end


# == Schema Information
#
# Table name: sequence_variants
#
#  id                    :integer(4)      not null, primary key
#  description           :string(255)
#  position              :string(255)
#  variation             :string(255)
#  gene_symbol           :string(255)
#  reference_sequence    :string(255)
#  coding                :boolean(1)
#  created_at            :datetime
#  updated_at            :datetime
#  gene_id               :integer(4)
#  condition_id          :integer(4)
#  indication_type_id    :integer(4)
#  biomarker_category_id :integer(4)
#  indication_modifier   :string(255)
#  comment               :string(255)
#

