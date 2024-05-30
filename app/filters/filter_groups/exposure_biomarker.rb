module FilterGroups
  class ExposureBiomarker < Unearth::Filters::FilterGroup
    CATEGORIES = %w[ diagnostic prognostic predictive exposure monitoring ]
    CATEGORIES_ID_HASH = {"diagnostic"=>2,"prognostic"=>3, "predictive"=>1,"exposure"=>4}
    FILTERS = {
      allchemical: 'All Chemicals',
      food: 'Food Chemicals',
      toxic: 'Toxic Chemicals',
    }.freeze

    def initialize()
      super('exposure-biomarker-filter', 'Filter by exposure biomarker type', FILTERS)
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
          when :allchemical
            selected_biomarker << "All"
          when :food
            selected_biomarker << "Food"
          when :toxic
            selected_biomarker << "Toxic"
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
      byebug
      biomarker_hash = Hash.new
      result = []
      if selected_biomarker.include? "Food" and selected_biomarker.include? "Toxic"
        result += BiomarkerCategoryMembership.where("biomarker_category_id = ?", CATEGORIES_ID_HASH[category]).select("biomarker_id","biomarker_name","mdbid","condition_id","condition_name", "biomarker_type")
      elsif selected_biomarker.include? "Food"
        puts "food biomarker"
        result += BiomarkerCategoryMembership.where("biomarker_category_id = ? and condition_name like ?", CATEGORIES_ID_HASH[category], "%consumption%").select("biomarker_id","biomarker_name","mdbid","condition_id","condition_name", "biomarker_type")
      elsif selected_biomarker.include? "Toxic"
        result += BiomarkerCategoryMembership.where("biomarker_category_id = ? and condition_name not like ?", CATEGORIES_ID_HASH[category], "%consumption%").select("biomarker_id","biomarker_name","mdbid","condition_id","condition_name", "biomarker_type")
      else
        result += BiomarkerCategoryMembership.where("biomarker_category_id = ?", CATEGORIES_ID_HASH[category]).select("biomarker_id","biomarker_name","mdbid","condition_id","condition_name", "biomarker_type")
      end
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
