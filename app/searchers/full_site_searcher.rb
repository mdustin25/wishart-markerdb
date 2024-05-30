class FullSiteSearcher
  include Unearth::Searcher::Searcher
  search_index "full_site"
  search_with :name, :basic, :fuzzy_like_this,
    name_fields: [:name, :synonyms],
    fuzzy_fields: [:name]


  def self.highlights
    { name: {},
      description: { number_of_fragments: 3 }
    }
  end


  # elasticsearch auto-suggestor
  # if @searcher.respond_to?(:suggestions)
  #   @suggestions = @searcher.suggestions(query)
  # end
  def self.suggestions(query)

    candidates = [
      {
        field: "name",
        suggest_mode: "popular",
        min_word_length: 1
      }
    ]

    self.index_class.suggestions(query, 'name', candidates)
  end

end
