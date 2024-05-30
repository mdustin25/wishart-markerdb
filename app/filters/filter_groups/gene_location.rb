module FilterGroups
  class GeneLocation < Unearth::Filters::FilterGroup

    FILTERS = {
      "1" => "Chrm 1",
      "2" => "Chrm 2",
      "3" => "Chrm 3",
      "4" => "Chrm 4",
      "5" => "Chrm 5",
      "6" => "Chrm 6",
      "7" => "Chrm 7",
      "8" => "Chrm 8",
      "9" => "Chrm 9",
      "10" => "Chrm 10",
      "11" => "Chrm 11",
      "12" => "Chrm 12",
      "13" => "Chrm 13",
      "14" => "Chrm 14",
      "15" => "Chrm 15",
      "16" => "Chrm 16",
      "17" => "Chrm 17",
      "18" => "Chrm 18",
      "19" => "Chrm 19",
      "20" => "Chrm 20",
      "21" => "Chrm 21",
      "22" => "Chrm 22",
      "x" => "Chrm X",
      "y" => "Chrm Y",
    }.freeze

    def initialize
      super('gene-location-filter', 'Filter by chromosome number', FILTERS)
    end

    def get_location_ids(applicable_filters)
      chromsome_pos = []
      applicable_filters.each do |applicable_filter|
        gene_ids = SequenceVariant.where("`sequence_variants`.chromosome = \"#{applicable_filter.strip()}\"").pluck(:id)
        chromsome_pos = chromsome_pos + gene_ids
      end
      return chromsome_pos
    end

    def apply_to_relation(relation, params)
      applicable_filters = self.parse(params)
      if applicable_filters.empty?
        return relation
      else
        return relation.where("sequence_variants.id IN (?)",get_location_ids(applicable_filters))
        
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
