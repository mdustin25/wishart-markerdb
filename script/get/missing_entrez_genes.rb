require 'rubygems'
require 'bio'
require 'progressbar'

Bio::NCBI.default_email = "2michaelwilson@gmail.com"

MissingGeneStruct = Struct.new(:file_name,:id)

file_name = "/Users/mike/marker_db/missing_disease_genes.txt"
file = File.open(file_name,"r")
genes = file.readlines.map do |line|
  line.strip!
  next if line.empty?
  col = line.split(/\t/)[0..1]
  MissingGeneStruct.new( *col )
end
file.close

def fetch_gene(gene)
  xml = Bio::NCBI::REST.efetch(gene.id,:db=>"gene","retmode" => "xml")
  file_name = "missing_disease_genes/#{gene.file_name}"
  puts "fetching #{file_name} with #{gene.id}"
  File.open(file_name,"w") do |f|
    f.puts xml
  end
end

#progress = ProgressBar.new("fetching", genes.count)
genes.each do |gene|
#progress.inc 
  fetch_gene(gene)
end
#progress.finish
