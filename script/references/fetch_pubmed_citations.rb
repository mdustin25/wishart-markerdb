require 'bio'
require 'activerecord-import'
require 'progressbar'

Bio::NCBI.default_email = "mwilson1@ualberta.ca"

#
# ref_string = Bio::PubMed.pmfetch("10592173") 
# ref = Bio::MEDLINE.new(ref_string)
# ref.reference.nature
# Bio::PubMed.efetch([123,456,789]).collect{|x| Bio::MEDLINE.new(x)}


ERRORS = File.open("pubmed_ref_errors","a")
ERRORS.print "id\tpubmed_id\terror\n"


def fetch_new_ref(ref)
  medline_string = Bio::PubMed.query(ref.pubmed_id)
  if medline_string[0..3] == "PMID"
    Bio::MEDLINE.new(medline_string).reference
  else
    ERRORS.print "#{ref.id}\t#{ref.pubmed_id}\t#{medline_string.strip}\n"
    nil
  end

end


refs_with_pubmed_id = Reference.where("(pubmed_id is not null) and (fetched is not true)")
progress = ProgressBar.new("Fetching pubmed info",refs_with_pubmed_id.size)

updates = []

error_msg = ""
back_trace = ""

begin 

  refs_with_pubmed_id.each do |ref|
    progress.inc

    new_ref = fetch_new_ref(ref)
    next if new_ref.nil?

    ref.citation = new_ref.nature
    ref.authors  = new_ref.authors * "; " 
    ref.year     = new_ref.year
    ref.title    = new_ref.title
    ref.embl_id  = new_ref.embl_gb_record_number
    ref.pages    = new_ref.pages
    ref.medline  = new_ref.medline
    ref.volume   = new_ref.volume
    ref.issue    = new_ref.issue
    ref.url      = new_ref.url
    ref.journal  = new_ref.journal
    ref.fetched  = true

    updates << ref.attributes

  end

rescue Exception => e
  error_msg = e.message
  back_trace     = e.backtrace.inspect
ensure
  progress.finish
  ERRORS.close

  print "Could not complete task due to error:\n#{error_msg}" unless error_msg.empty?
  puts back_trace unless back_trace.empty?

  yam = File.open("updated_references.yaml","w");
  yam.print updates.to_yaml 
  yam.close
  #Reference.import updates, :on_duplicate_key_update => [:id]

end

