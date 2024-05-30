module CitationOwner 
  extend ActiveSupport::Concern

  included do
    has_many :citations, 
      :as => :citation_owner,
      :dependent => :destroy
    has_many :references,
      :through   => :citations

    accepts_nested_attributes_for :citations
  end
end


