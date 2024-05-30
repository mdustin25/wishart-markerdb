module Advanced  
  class ProteinIndex
    include Unearth::Index::Indexable

    set_index_name 'advanced_proteins'
    set_default_field 'synonyms'
    # Scopes that are used to build the index.
    def self.indexed_document_scopes
      [ Protein.includes(:marker_mdbid).exported ]
    end

    mapping do
      indexes :id, type: :keyword
      indexes :markerdb_id, as: "marker_mdbid.mdbid", type: :keyword
      indexes :name, type: :keyword
      indexes :synonyms, as: Proc.new{ try(:names) }, type: :text
      indexes :description, type: :text
      indexes :gene_name, type: :text
      indexes :uniprot_id, type: :text
      indexes :uniprot_name, type: :text
      indexes :genecard_id, type: :text
      indexes :mdbid, type: :text
      indexes_with_exact :name, type: :text
      indexes_with_exact :gene_name, type: :text
      indexes_with_exact :uniprot_name, type: :text
      indexes_with_exact :genecard_id, type: :text
      indexes_with_exact :mdbid, type: :text
      indexes_with_exact :name, type: :text
    end

    def self.searchable_fields
      reject = [:id, :model_type, :name]
      fields = []

      self.mapping.each do |field, options|
        next if field =~ /.+\_exact\z/
        next if reject.include? field
        fields << field
      end

      fields
    end
  end
end