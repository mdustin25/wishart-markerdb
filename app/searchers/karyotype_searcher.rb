class KaryotypeSearcher
  include Unearth::Searcher::Searcher
  search_index "karyotypes"
  search_with :name, :basic, :fuzzy_like_this,
    name_fields: [:name],
    fuzzy_fields: [:name]

  def self.highlights
    { name: {},
      synonyms: { number_of_fragments: 3 },
      description: { number_of_fragments: 3 },
      ideo_description: { number_of_fragments: 3 }
    }
  end

  def self.suggestions(query)

    candidates = [
      {
        field: "name",
        suggest_mode: "popular",
        min_word_length: 2
      }
    ]

    self.index_class.suggestions(query, "name", candidates)
  end

end
