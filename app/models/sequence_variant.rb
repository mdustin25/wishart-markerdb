class SequenceVariant < ActiveRecord::Base
  include Biomarker
  include Aliasable
  include Linkable
  include CitationOwner
  
  belongs_to :gene
  has_many :sequence_variant_measurements
  has_one :marker_mdbid, as: :identifiable
  has_many :gene_sequences, as: :sequenceable, dependent: :destroy

  scope :exported, ->{where("exported = 1")}

  # def measurements
  #   sequence_variant_measurements
  # end
  
  # set_marker_tag  "S"
  # set_marker_type "Genetic"

  def self.search_text(search)
    if search
      SequenceVariant.joins(:gene).where("`sequence_variants`.exported and (`genes`.gene_symbol like \"%#{search}%\" or `genes`.name like \"%#{search}%\")")
    else
      SequenceVariant.exported
    end
  end
  
    
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

