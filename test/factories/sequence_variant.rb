FactoryGirl.define do
  factory :sequence_variant_measurement do
    biomarker_category_id 1
    sequence_variant
    indication_type
    biomarker_category
    condition
  end

  factory :sequence_variant do 
    sequence(:variation) {|n| "mutation#{n}"}
    description "this is a variant"
    position "p12.3"
    gene_symbol "recessive"
#    association :condition, :factory => :condition
#    association :indication_type, :factory => :indication_type
#    association :gene, :factory => :gene
  end 
end
