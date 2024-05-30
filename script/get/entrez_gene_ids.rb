require 'rubygems'
require 'bio'
require 'progressbar'

Bio::NCBI.default_email = "2michaelwilson@gmail.com"

def fetch_id(gene)
  search_string = %{("#{gene}"[Gene Name]) AND "homo sapiens"[Organism]}
  Bio::NCBI::REST.esearch( search_string,:db=>"gene","retmode" => "xml")
end

file_name = "/Users/bbartok/marker_db/transfer/gene/genecard_disease_gene.csv"
file = File.open(file_name,"r")
gene_names = file.readlines.map(&:strip)
file.close

out = File.open("gene_name_to_id.csv","w")
progress = ProgressBar.new("fetching", gene_names.count)
gene_names.each do |gene|
  progress.inc
  row = "#{gene} #{fetch_id(gene) * ";"}"
  puts row
  out.puts row
end
out.close
progress.finish


