require 'rubygems'
require 'bio'
require 'progressbar'

Bio::NCBI.default_email = "2michaelwilson@gmail.com"

GeneStruct = Struct.new(:name,:id)

file_name = "/Users/mike/marker_db/marker_db/disease_gene_ids.txt"
file = File.open(file_name,"r")
genes = file.readlines.map do |line|
  line.strip!
  GeneStruct.new( *line.split(/\s+/) )
end
file.close

def fetch_gene(gene)
  xml = Bio::NCBI::REST.efetch(gene.id,:db=>"gene","retmode" => "xml")
  File.open("disease_genes/#{gene.name}.xml","w") do |f|
    f.puts xml
  end
end

progress = ProgressBar.new("fetching", genes.count)
genes.each do |gene|
  progress.inc 
  fetch_gene(gene)
end
progress.finish
