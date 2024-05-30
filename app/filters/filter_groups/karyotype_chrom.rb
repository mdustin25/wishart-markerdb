module FilterGroups
  class KaryotypeChrom < Unearth::Filters::FilterGroup

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
      "X" => "Chrm X",
      "Y" => "Chrm Y",
    }.freeze

    def initialize
      super('karyotype-chrom-filter', 'Filter by chromosome number', FILTERS)
    end

    def get_location_ids(applicable_filters)
      chromosome_pos = []
      applicable_filters.each do |applicable_filter|
        karyotypes = Karyotype.where("exported = true")
        karyotypes.each do |each_karyo|
          chrom_involved = each_karyo.chromosome_involved.split(";").map { |each| each.strip() }
          if chrom_involved.include?(applicable_filter)
            unless chromosome_pos.include?(each_karyo.id)
              chromosome_pos << each_karyo.id
            end
          end
        end
      end
      return chromosome_pos
    end

    def apply_to_relation(relation, params)
      applicable_filters = self.parse(params)
      if applicable_filters.empty?
        return relation
      else
        return relation.where("karyotypes.id IN (?)",get_location_ids(applicable_filters))
        
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
