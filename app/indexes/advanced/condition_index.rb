module Advanced  
  class ConditionIndex
    include Unearth::Index::Indexable

    set_index_name 'advanced_conditions'
    set_default_field 'synonyms'
    # Scopes that are used to build the index.
    def self.indexed_document_scopes
      [ Condition.exported ]
    end

    mapping do
      indexes :id, type: :keyword
      indexes :name, type: :keyword, boost: 300
      indexes :synonyms, as: Proc.new{ try(:names) }, type: :text
      indexes :description, type: :text
      indexes :RefSeq_ID, 
        as: Proc.new { self.single_nucleotide_polymorphisms.map(&:snp_id) }, type: :keyword
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
