class FullSiteIndex
  include Unearth::Index::Indexable

  set_index_name 'full_site'

#   # Scopes that are used to build the index.
  def self.indexed_document_scopes
    scopes = []
    scopes << Condition.includes(:aliases,:marker_mdbid).exported
    scopes << Chemical.includes(:aliases,:marker_mdbid).exported
    # scopes << Karyotype.includes(:marker_mdbid)
    scopes << Gene.includes(:aliases,:marker_mdbid).exported
    scopes << Protein.includes(:aliases,:marker_mdbid).exported
    return scopes
  end

  mapping do
    indexes :id, type: :keyword
    indexes :name, type: :text, boost: 1000
    indexes :description, type: :text, boost: 100
  end


end
