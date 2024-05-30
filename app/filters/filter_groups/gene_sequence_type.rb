module FilterGroups
  class GeneSequenceType < Unearth::Filters::FilterGroup

    FILTERS = {
      "Bacterial" => "Bacterial",
      "Human" => "Human",
      "Virus" => "Virus"
    }.freeze

    def initialize
      super('gene-sequence-type-filter', 'Filter by gene sequence type', FILTERS)
    end

    def get_ids(applicable_filters)
      all_ids = Array.new
      applicable_filters.each do |applicable_filter|
        seqvars = SequenceVariant.where("exported = true and source = \"#{applicable_filter}\"").pluck(:id)        
        all_ids = all_ids + seqvars
      end
      return all_ids
    end

    def apply_to_relation(relation, params)
      applicable_filters = self.parse(params)
      if applicable_filters.empty?
        return relation
      else
        return relation.where("sequence_variants.id IN (?)",get_ids(applicable_filters))
        
      end
    end

    def apply_to_searcher(terms={}, params)
      applicable_filters = self.parse(params)
      unless applicable_filters.empty?
        terms[:name] = applicable_filters
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
