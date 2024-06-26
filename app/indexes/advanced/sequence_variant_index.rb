module Advanced  
  class SequenceVariantIndex
    include Unearth::Index::Indexable

    set_index_name 'advanced_sequence_variant'
    set_default_field 'description'
    # Scopes that are used to build the index.
    def self.indexed_document_scopes
      # [Gene.includes(:marker_mdbid).exported]
      [ SequenceVariant.exported]
    end

    mapping do
      indexes :id, type: :keyword
      indexes :type, as: Proc.new{|o| self.class.to_s }, type: :text
      indexes :description, type: :text
      indexes :gene_symbol, type: :text
      indexes :variation, type: :text
     # indexes :omim_id, type: :keyword
      #indexes :genetic_type, type: :text
      #indexes :coding, type: :boolean
      indexes :position, as: "position", type: :text
      indexes :chromosome, type: :integer
      #indexes_with_exact :name, type: :text
    end


    def self.searchable_fields
      reject = [:id, :model_type]
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
