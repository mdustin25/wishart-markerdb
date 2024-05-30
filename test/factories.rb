#################################################
# Markers 
#################################################
FactoryGirl.define do 
  
  factory :gene do 
    # this is a factory girl function
    sequence(:name) {|n| "Gene in genome #{n}"}
    sequence(:gene_symbol) {|n| "GENE#{n}"}
    description "This is a description of a gene"
    source_common "human"
    source_taxname "Homo Sapien"
    dominance "recessive"
    genetic_type "mutation"
    # this is a bit of a kludge to set the sequence data member since 
    # there is already a function called sequence...
    sequence(:sequence) do |n| 
      ">gi|219517763|gb|BC143259.1| Homo sapiens cDNA clone IMAGE:9051761
    GAGTTTGGCTGCTCCGGGGTTAGCAGGTGAGCCTGCGATGCGCGGGAAGACGTTCCGCTTTGAAATGCAG 
    CGGGATTTGAAGTTGGGATATCTAAAGCAGAAGCCTTAGAAACTCTGCAAATTATCAGAAGAGAATGTCT 
    CACAAATAAACCAAGATATGCTGGTACATCTGAGTCACACAAGAAGTGTACAGCACTGGAACTTCTTGAG 
    CAGGAGCATACCCAGGGCTTCATAATCACCTTCTGTTCAGCACTAGATGATATTCTTGGGGGTGGAGTGC 
    CCTTAATGAAAACAACAGAAATTTGTGGTGCACCAGGTGTTGGAAAAACACAATTATGTATGCAGTTGGC 
    AGTAGATGTGCAGATACCAGAATGTTTTGGAGGAGTGGCAGGTGAAGCAGTTTTTATTGATACAGAGGGA 
    AGTTTTATGGTTGATAGAGTGGTAGACCTTGCTACTGCCTGCATTCAGCACCTTCAGCTTATAGCAGAAA 
    AACACAAGGGAGAGGAACACCGAAAAGCTTTGGAGGATTT"
    end
  end

  factory :protein do 
    sequence(:name) {|n| "BRCA#{n}"}
    description "This is a description of a protein marker"
    source "human"
    #molecule_type "membrane protein"
  end

  #################################################
  # Links 
  #################################################

  factory :link_type do 
    prefix "http://www.prefix.com/"
    suffix "/suffix"
    name   "test"
  end

  factory :external_link do 
    key "key"
    association :link_type, :factory => :link_type
  end

  #################################################
  # Condition 
  #################################################

  factory :condition do 
    sequence(:name) {|n| "disease#{n}"}
    description 'An unhealthy condition'
    organism 'e.coli' 

    factory :sub_condition do 
      association :super_condition, :factory => :condition
      sequence(:name){|n| "Type #{n}"}
    end


    factory :healthy_condition do 
      name 'Normal'
      description 'Normal level of health'
    end
  end
  factory :condition_category do 
    sequence(:name){|n| "category #{n}"}
  end

  #################################################
  # Biomarker
  #################################################

  factory :biomarker_category do 
    sequence(:name){|n| "category #{n}"}
    description 'description'
  end

  factory :indication_type do 
    association :biomarker_category, :factory => :biomarker_category
  end


  #################################################
  # Measurements 
  #################################################

  factory :concentration do 
    level "0.9007 (0.10081 - 0.10124) uM"
    age_range "Adult > 18"
    comment "this is a comment about the level, like level only available from morning tests"
    location_name "Blood"
    association :condition, :factory => :condition
    association :indication_type, :factory => :indication_type
    association :solute, :factory => :chemical

    factory :abnormal_concentration do 
    end

    factory :normal_concentration do 
      association :condition
    end
  end

  #################################################
  # Other models 
  #################################################

  factory :alias do 
    sequence(:name){|n| "Name#{n}"}
  end

  factory :lab_test_ownership do 
    association :lab_test, :factory => :lab_test
    association :lab_test_owner, :factory => :gene
  end

  factory :lab_test do 
    sequence(:name) {|n| "test#{n}"}
    description "this is a test"
  end

  factory :reference do 
    title "Oral brush biopsy analysis by matrix assisted laser desorption/ionisation-time of flight mass spectrometry profiling - A pilot study."
    citation "Remmerbach, T. W., Maurer, K., Janke, S., Schellenberger, W., Eschrich, K., Bertolini, J., Hofmann, H. & Rupf, S. Oral brush biopsy analysis by matrix assisted laser desorption/ionisation-time of flight mass spectrometry profiling--a pilot study. Oral Oncol 47, 278-281 (2011)."
    pages "278-281"
    volume "47"
    issue "4"
    journal "Oral Oncol"
    authors "Remmerbach TW, Maurer K, Janke S, Schellenberger W, Eschrich K, Bertolini J, Hofmann H, Rupf S."
    year "2011 Feb 25."
  end

end
