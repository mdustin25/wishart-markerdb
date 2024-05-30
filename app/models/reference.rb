class Reference < ActiveRecord::Base
  has_many :citations
  has_many :citation_owners, through: :citations

  # finds reference, or creates it, filling with
  # data fetched from pubmed
  def self.find_or_create_by_pubmed_id(pubmed_id)
    self.find_by(pubmed_id: pubmed_id) || self.create_by_pubmed_id(pubmed_id)
  end

  def self.create_from_pubmed_id(pubmed_id)
    # Build the reference, then save it, and return the new reference
    self.build_from_pubmed_id(pubmed_id).tap(&:save!)
  end

  def self.build_from_pubmed_id(pubmed_id)
    pubmed_ref = PubmedFetcher.fetch(pubmed_id).first

    self.new(
      :citation => pubmed_ref.nature,
      :authors  => (pubmed_ref.authors * "; ") ,
      :year     => pubmed_ref.year,
      :title    => pubmed_ref.title,
      :embl_id  => pubmed_ref.embl_gb_record_number,
      :pages    => pubmed_ref.pages,
      :medline  => pubmed_ref.medline,
      :volume   => pubmed_ref.volume,
      :issue    => pubmed_ref.issue,
      :url      => pubmed_ref.url,
      :journal  => pubmed_ref.journal,
      :pubmed_id => pubmed_ref.pubmed,
      :fetched  => true
    )
  end
end
