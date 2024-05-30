module Advanced
	class BiomarkerIndex
	    include Unearth::Index::Indexable

	  	set_index_name 'advanced_biomarkers'
	  	set_default_field 'synonyms'
	  # Scopes that are used to build the index.
	  	def self.indexed_document_scopes
	    	scopes = []
	    	scopes << Chemical.includes(:aliases, :marker_mdbid).exported
	    	scopes << Karyotype.includes(:marker_mdbid)
	    	scopes << Gene.includes(:aliases, :marker_mdbid).exported
	    	scopes << Protein.includes(:aliases, :marker_mdbid).exported

	    	return scopes
	  	end

	  	mapping do
	    	indexes :id, type: :keyword
	    	# indexes :markerdb_id, as: "marker_mdbid.mdbid", type: :keyword
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