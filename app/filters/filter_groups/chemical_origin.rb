module FilterGroups
  class MetaboliteOrigin < Unearth::Filters::FilterGroup
    FILTERS = {
      exogenous:       "Exogenous",
      endogenous:      "Endogenous"
    }.freeze

    def initialize()
      super('origin-filter', 'Filter by origin', FILTERS)
    end

    def apply_to_relation(relation, params)
      applicable_filters = self.parse(params)
      if applicable_filters.empty?
        relation
      else
        relation = relation.joins(:ontology) unless relation.name == "Ontology"
        relation.
          merge(Ontology.filter_by_origin(applicable_filters)).
          uniq
      end
    end

    def apply_to_searcher(terms={}, params)
      applicable_filters = self.parse(params)
      unless applicable_filters.empty?
        terms[:origin_filter] = applicable_filters
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
