# pull the entrez gene ids out of the xml files
# because I forgot to in the other script

mapper = XMLMapper.build_mapper_for GeneticBm do
  m :entrez_gene_id, "//Gene-track/Gene-track_geneid"
end

all_files = Dir.glob( File.expand_path("~/marker_db/disease_genes/*") )
all_objects = []

errors = []

progress = ProgressBar.new("parsing", all_files.count)
all_files.each do |file_name|

  file = File.open(file_name,"r")
  doc = Nokogiri::XML(file)

  gene_name = doc.xpath("//Entrezgene_gene/Gene-ref/Gene-ref_locus").first.content
  genetic_bm = GeneticBm.find_by_gene gene_name

  if genetic_bm.nil? 
    errors << gene_name + " not found"
    next
  end

  all_objects += mapper.
    update(genetic_bm, doc).
    mapped_objects

  progress.inc
end
progress.finish

puts errors * "\n"

GeneticBm.import all_objects, 
  :on_duplicate_key_update => [:entrez_gene_id]
 

