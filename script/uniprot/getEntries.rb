require './script/uniprot/uniprot_parser'
require 'progressbar'


file_path = ARGV[0]
uniprot = UniprotParser.new(file_path)
entry_count = `grep -c "<entry" #{file_path}`.to_i
progress = ProgressBar.new("scanning uniprot",entry_count)

uniprot.each_entry do |entry|
  progress.inc
  
  # get refs
  entry.search("reference").each do |ref|
    new_ref = Ref.new
    new_ref.authors = ref.search("person").map{|x| x["name"]}i * ";"
  end

end
progress.finish


