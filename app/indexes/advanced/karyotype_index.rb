module Advanced  
  class KaryotypeIndex
    include Unearth::Index::Indexable

    set_index_name 'advanced_karyotypes'
    set_default_field 'description'
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