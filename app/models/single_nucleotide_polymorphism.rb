class SingleNucleotidePolymorphism < ActiveRecord::Base

  include Biomarker
  
  belongs_to :gene
  belongs_to :condition
  # set_marker_tag  "S"
  # set_marker_type "Genetic"
end
