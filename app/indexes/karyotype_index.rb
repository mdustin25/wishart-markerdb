class KaryotypeIndex
  include Unearth::Index::Indexable

  set_index_name 'karyotypes'

  # Scopes that are used to build the index.
  def self.indexed_document_scopes
    [ Karyotype.includes(:marker_mdbid).exported ]
  end
  
  mapping do
    indexes :id, type: :keyword
    indexes :markerdb_id, as: "marker_mdbid.mdbid", type: :keyword
    indexes :gender, type: :text
    indexes :description, type: :text
    indexes :ideo_description, type: :text
    indexes :name, as: "karyotype", type: :keyword

    # indexes_with_exact :name, type: :text
  end
  


end
