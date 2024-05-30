
  class ChemicalIndex
    include Unearth::Index::Indexable

    set_index_name 'chemicals'

    # Scopes that are used to build the index.
    def self.indexed_document_scopes
      [ Chemical.includes(:marker_mdbid).exported ]
    end

    mapping do
      indexes :id, type: :keyword
      indexes :moldb_iupac, type: :keyword
      indexes :markerdb_id, as: "marker_mdbid.mdbid", type: :keyword
      indexes :hmdb_id, as: "hmdb", type: :keyword
      indexes :name, type: :text
      indexes :synonyms, as: Proc.new{ try(:names) }, type: :text
      indexes :description, type: :text

      indexes_with_exact :name, type: :text
    end
  end

