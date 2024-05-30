class ProteinSearcher
  include Unearth::Searcher::Searcher
  search_index "proteins"
  search_with :name, :basic, :fuzzy_like_this,
    name_fields: [:name],
    fuzzy_fields: [:name]

  def self.highlights
    { name: {number_of_fragments: 3},
      synonyms: { number_of_fragments: 3 },
      description: { number_of_fragments: 3 },
      uniprot_id: {number_of_fragments: 1},
      gene_name: {number_of_fragments: 1}
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

    self.index_class.suggestions(query, 'name', candidates)
  end
end
