module FilterGroups
  class BiomarkerType < Unearth::Filters::FilterGroup
    CATEGORIES = %w[ diagnostic prognostic predictive exposure monitoring ]
    CATEGORIES_ID_HASH = {"diagnostic"=>2,"prognostic"=>3, "predictive"=>1,"exposure"=>4}
    FILTERS = {
      chemical: 'Chemical',
      protein: 'Protein',
      sequence_variant: 'Genetic',
      karyotype: 'Karyotype',
    }.freeze

    def initialize()
      super('biomarker-type-filter', 'Filter by biomarker type', FILTERS)
    end


    # this method call the BiomarkerCategoryMembership.where four times, which is not fesiable, should only called once
    def apply_to_relation(relation, params)
      applicable_filters = self.parse(params)

      category = params[:marker_category]

      if applicable_filters.empty?
        
        relation = [*relation, *obtain_all_marker_by_category(category)].to_h

        # relation = [*relation, *obtain_karyotype_marker_by_category(category),
        #           *obtain_protein_marker_by_category(category),
        #           *obtain_chemical_marker_by_category(category),
        #           *obtain_seqvar_marker_by_category(category)].to_h
        relation

      else
        selected_biomarker = []
        applicable_filters.each do |filter|
          case filter
          when :karyotype
            selected_biomarker << "Karyotype"
          when :protein
            selected_biomarker << "Protein"
          when :chemical
            selected_biomarker << "Chemical"
          when :sequence_variant
            selected_biomarker << "SequenceVariant"
          end
        end

        relation = [*relation, *obtain_biomarker_with_filter(category, selected_biomarker)].to_h
        
      end
      return relation
    end

    def obtain_all_marker_by_category(category)
      biomarker_hash = Hash.new

      result = BiomarkerCategoryMembership.where(:biomarker_category_id => CATEGORIES_ID_HASH[category]).select("biomarker_id","biomarker_name","mdbid","condition_id","condition_name", "biomarker_type")
      result.each do |marker|
        key = {
               "biomarker_id" => marker.biomarker_id,
               "biomarker_type" => marker.biomarker_type
              }

        if biomarker_hash.keys.include?(key)
          biomarker_hash[key] << {
                                  "biomarker_id" => marker.biomarker_id,
                                  "biomarker_type" => marker.biomarker_type,
                                  "biomarker_name" => marker.biomarker_name,
                                  "mdbid" => marker.mdbid,
                                  "condition_id" => marker.condition_id,
                                  "condition_name"=>marker.condition_name
                                  }
        else

          biomarker_hash[key] = [{
                                  "biomarker_id" => marker.biomarker_id,
                                  "biomarker_type" => marker.biomarker_type,
                                  "biomarker_name" => marker.biomarker_name,
                                  "mdbid" => marker.mdbid,
                                  "condition_id" => marker.condition_id,
                                  "condition_name"=>marker.condition_name
                                }]
        end
      end

      return biomarker_hash

    end

    def obtain_biomarker_with_filter(category, selected_biomarker)
      biomarker_hash = Hash.new

      result = BiomarkerCategoryMembership.where("biomarker_category_id = ? and biomarker_type in (?)", CATEGORIES_ID_HASH[category], selected_biomarker).select("biomarker_id","biomarker_name","mdbid","condition_id","condition_name", "biomarker_type")
      # puts "result => #{result.length}"
      result.each do |marker|
        key = {
               "biomarker_id" => marker.biomarker_id,
               "biomarker_type" => marker.biomarker_type
              }
        if biomarker_hash.keys.include?(key)
          biomarker_hash[key] << {
                                  "biomarker_id" => marker.biomarker_id,
                                  "biomarker_type" => marker.biomarker_type,
                                  "biomarker_name" => marker.biomarker_name,
                                  "mdbid" => marker.mdbid,
                                  "condition_id" => marker.condition_id,
                                  "condition_name"=>marker.condition_name
                                  }
        else

          biomarker_hash[key] = [{
                                  "biomarker_id" => marker.biomarker_id,
                                  "biomarker_type" => marker.biomarker_type,
                                  "biomarker_name" => marker.biomarker_name,
                                  "mdbid" => marker.mdbid,
                                  "condition_id" => marker.condition_id,
                                  "condition_name"=>marker.condition_name
                                }]
        end
      end

      return biomarker_hash

    end

    # following should change to biomarker_type in ("SequenceVariant", "...")

    def obtain_seqvar_marker_by_category(category)
      sequence_variant_hash = Hash.new
      # obtain all sequence variant for particular biomarker category and these are abnormal ones
      seq_var_bmcat = BiomarkerCategoryMembership.where("biomarker_category_id = ? and biomarker_type = ?", CATEGORIES_ID_HASH[category],"SequenceVariant").select("biomarker_id","biomarker_name","mdbid","condition_id","condition_name")
      seq_var_bmcat.each do |seq_var_meas|
        key = {
                "biomarker_id" => seq_var_meas.biomarker_id,
                "biomarker_type" => "SequenceVariant",
                "biomarker_name" => seq_var_meas.biomarker_name,
                "mdbid" => seq_var_meas.mdbid
              }
        if sequence_variant_hash.keys.include?(key)
          sequence_variant_hash[key] << {"condition_id"=>seq_var_meas.condition_id,
                                            "condition_name"=>seq_var_meas.condition_name,
                                            }
        else
          sequence_variant_hash[key] = [{"condition_id"=>seq_var_meas.condition_id,
                                            "condition_name"=>seq_var_meas.condition_name,
                                            }]
        end
      end
      return sequence_variant_hash
    end

    def obtain_protein_marker_by_category(category)
      proteins_hash = Hash.new
      prot_bmcat = BiomarkerCategoryMembership.where("biomarker_category_id = ? and biomarker_type = ?",CATEGORIES_ID_HASH[category],"Protein").select("biomarker_id","biomarker_name","mdbid","condition_id","condition_name","biomarker_structure")
      prot_bmcat.each do |each_prot|
        # puts "each_prot.biomarker_id => #{each_prot.biomarker_id}"
        protein = Protein.find_by(:id => each_prot.biomarker_id)
        unless protein.nil?
          key = {"biomarker_id" => each_prot.biomarker_id,
                  "biomarker_type" => "Protein",
                  "biomarker_name" => each_prot.biomarker_name,
                  "mdbid" => each_prot.mdbid,
                  "biomarker" => protein}
          if proteins_hash.keys.include?(key)
            proteins_hash[key] << {"condition_id"=>each_prot.condition_id,
                                      "condition_name"=>each_prot.condition_name}
          else
            proteins_hash[key] = [{"condition_id"=>each_prot.condition_id,
                                      "condition_name"=>each_prot.condition_name}]
          end
        end
      end
      return proteins_hash
    end

    def obtain_chemical_marker_by_category(category)
      chemicals_hash = Hash.new
      chem_bmcat = BiomarkerCategoryMembership.where("biomarker_category_id = ? and biomarker_type = ?",CATEGORIES_ID_HASH[category],"Chemical").select("biomarker_id","biomarker_name","mdbid","condition_id","condition_name","biomarker_structure")
      chem_bmcat.each do |each_chem|
        chem = Chemical.where("id = ?",each_chem.biomarker_id).first
        unless chem.nil?
          key = {"biomarker_id" => each_chem.biomarker_id,
                  "biomarker_type" => "Chemical",
                  "biomarker_name" => each_chem.biomarker_name,
                  "mdbid" => each_chem.mdbid,
                  "biomarker" => chem}
          if chemicals_hash.keys.include?(key)
            chemicals_hash[key] << {"condition_id"=>each_chem.condition_id,
                                      "condition_name"=>each_chem.condition_name}
          else
            chemicals_hash[key] = [{"condition_id"=>each_chem.condition_id,
                                      "condition_name"=>each_chem.condition_name}]
          end
        end
      end
      return chemicals_hash
    end
    def obtain_karyotype_marker_by_category(category)
      # obtain all karyotype for a particular category
      karyotypes_hash = Hash.new
      karyo_bmcat = BiomarkerCategoryMembership.where("biomarker_category_id = ? and biomarker_type = ?",CATEGORIES_ID_HASH[category],"Karyotype").select("biomarker_id","biomarker_name","mdbid","condition_id","condition_name","biomarker_structure")
      karyo_bmcat.each do |each_karyo|
        karyo = Karyotype.where("id = ?",each_karyo.biomarker_id).first
        unless karyo.nil?
          key = {"biomarker_id" => each_karyo.biomarker_id,
                  "biomarker_type" => "Karyotype",
                  "biomarker_name" => each_karyo.biomarker_name,
                  "mdbid" => each_karyo.mdbid,
                  "biomarker" => karyo}
          if karyotypes_hash.keys.include?(key)
            karyotypes_hash[key] << {"condition_id"=>each_karyo.condition_id,
                                      "condition_name"=>each_karyo.condition_name}
          else
            karyotypes_hash[key] = [{"condition_id"=>each_karyo.condition_id,
                                      "condition_name"=>each_karyo.condition_name}]
          end
        end
      end
     
      return karyotypes_hash
    end

    def apply_to_searcher(terms={}, params)
      applicable_filters = self.parse(params)
      unless applicable_filters.empty?
        terms[:biofluid_source] = applicable_filters
      end
      terms
    end

    def parse(params)
      self.filters.keys.select do |filter_param|
        params[filter_param] == '1'
      end
    end
  end
end
