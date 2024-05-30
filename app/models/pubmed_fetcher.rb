class PubmedFetcher
  class PubmedFetcherError < StandardError; end

  # ensure the email variable is set for bioruby
  if Bio::NCBI.default_email.nil? 
    Bio::NCBI.default_email = "mwilson1@ualberta.ca"
  end

  # Assumes the pubmed ids exist, returns nil if not
  def self.fetch(pubmed_ids)
    Bio::PubMed.efetch(pubmed_ids).map do |result|
      next if result.nil?
      # Map the medline string to the handy reference object
      Bio::MEDLINE.new(result).reference
    end
  end

end
