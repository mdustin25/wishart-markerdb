class GeneticMarkerIndex
  include Unearth::Index::Indexable

  set_index_name 'genetic_markers'

  # Scopes that are used to build the index.
  def self.indexed_document_scopes
    # [Gene.includes(:marker_mdbid).exported]
    [ Gene.includes(:marker_mdbid).exported ]
  end

  mapping do
    indexes :id, type: :keyword
    indexes :type, as: Proc.new{|o| self.class.to_s }, type: :text
    indexes :name, type: :keyword
    indexes :synonyms, as: Proc.new{ try(:names) }, type: :text
    indexes :description, type: :text
    indexes :gene_symbol, type: :text
    indexes :omim_id, type: :keyword
    indexes :genetic_type, type: :text
    indexes :chromosome_position, as: "position", type: :text
    indexes_with_exact :name, type: :text
  end

end
