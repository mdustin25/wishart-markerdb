module BiomarkerCategoryScopes 
    CATEGORY_MAP = {
      predictive: 1,
      diagnostic: 2,
      prognostic: 3,
      exposure: 4,
      monitoring: 5
    }

    def by_category(category_name)
      category_name = category_name.downcase.to_sym
      where :biomarker_category_id => CATEGORY_MAP[category_name]
    end

    def only_category(id)
      where :biomarker_category_id => id
    end

    def predictive
      by_category :predictive
    end
    
    def diagnostic
      by_category :diagnostic
    end
    
    def prognostic
      by_category :prognostic
    end
    
    def exposure
      by_category :exposure
    end
    
    def monitoring
      by_category :monitoring
    end
end
