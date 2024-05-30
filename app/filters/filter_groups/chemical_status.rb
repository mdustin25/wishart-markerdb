module FilterGroups
  class MetaboliteStatus < Unearth::Filters::FilterGroup
    FILTERS = {
      quantified: "Detected and quantified",
      detected:   "Detected but not quantified",
      expected:   "Expected but not quantified"
    }.freeze

    def initialize
      super('status-filter', 'Filter by metabolite status (default all)', FILTERS)
    end

    def apply_to_relation(relation, params)
      # unless relation.name == "Metabolite"
      #   raise "Invalid relation passed to metabolite status filter: #{relation.name}"
      # end

      applicable_filters = self.parse(params)
      if applicable_filters.empty?
        relation
      else
        statuses = applicable_filters.map { |f| Metabolite.statuses[f.to_s] }
        relation.where(metabolites: { status: statuses })
      end
    end

    def apply_to_searcher(terms={}, params)
      applicable_filters = self.parse(params)
      unless applicable_filters.empty?
        terms[:status] = applicable_filters
      end
      terms
    end

    def parse(params)
      self.filters.keys.select do |filter_param|
        params[filter_param] == '1'
      end
    end

    def self.statuses
      FILTERS
    end
  end
end
