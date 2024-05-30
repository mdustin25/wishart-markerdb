module Advanced  
  class GeneticMarkerIndex
    include Unearth::Index::Indexable

    set_index_name 'advanced_genetic_markers'
    set_default_field 'synonyms'
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
      indexes :RefSeq_ID, as: Proc.new { self.single_nucleotide_polymorphisms.map(&:snp_id) }, type: :keyword
      indexes :chromosome_position, as: "position", type: :text
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
