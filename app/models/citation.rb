class Citation < ActiveRecord::Base
  belongs_to :citation_owner, 
    :polymorphic => true
  belongs_to :reference

  validates :citation_owner, :reference, :presence => true
  #uniqueness of (citation_owner_id, citation_owner_type,  reference_id) 
  # is enforced by the database

  # adding pubmed id automatically fetches reference from 
  # pubmed
  def pubmed_id=(pubmed_id_string)
    reference = Reference.find_or_create_by_pubmed_id(pubmed_id_string)
    self.reference = reference
  end

  def text_citation
    self.reference.citation
  end
  
  def pubmed_id
    reference.pubmed_id
  end

end
