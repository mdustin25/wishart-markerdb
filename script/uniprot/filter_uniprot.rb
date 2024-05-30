require './script/uniprot/uniprot_parser'
require 'progressbar'


file_path = ARGV[0]
uniprot = UniprotParser.new(file_path)
progress = ProgressBar.new("scanning uniprot",529056)

out = File.open("only_disease_uniprot.xml","w")

uniprot.each_entry do |entry|
progress.inc

# only return entries for humans
next unless entry.search("organism/name[@type='common']").text == "Human"

# only return entries related to diseases
next if entry.css("comment [@type=disease]").size == 0

out.print entry 

end
out.close
progress.finish


