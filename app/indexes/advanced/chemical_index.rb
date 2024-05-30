module Advanced  
  class ChemicalIndex
    include Unearth::Index::Indexable

    set_index_name 'advanced_chemicals'
    set_default_field 'synonyms'
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
