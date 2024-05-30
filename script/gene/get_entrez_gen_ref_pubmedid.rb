
all_files = Dir.glob( File.expand_path("~/marker_db/disease_genes/*") )

existing_ids = Reference.select(:pubmed_id).map(&:pubmed_id).to_set
pubmed_ids = Set.new

progress = ProgressBar.new("parsing", all_files.count)
all_files.each do |file_name|
  progress.inc

  file = File.open(file_name,"r")
  doc = Nokogiri::XML(file)

  pubmed_id_path = '//Entrezgene_comments//Gene-commentary_refs/Pub//PubMedId'
  doc.xpath(pubmed_id_path).each do |node|
    id = node.content
    next if existing_ids.include? id
    pubmed_ids << id
  end
end
progress.finish

print "Saving ids ... "
File.open "entrezgene_pubmed_ids_to_fetch.csv","w" do |f|
  f.puts pubmed_ids.to_a * "\n"
end
puts "done"

#print "Fetching #{pubmed_ids.count} references... "
#new_references = PubmedFetcher.fetch_batch(pubmed_ids.to_a)
#puts "done"
#
#print "Importing... "
#Reference.import new_references
#puts "done"

