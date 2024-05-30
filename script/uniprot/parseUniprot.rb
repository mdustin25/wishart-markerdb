require 'yaml'

file_path = ARGV[0]
file = File.open(file_path)

def parse_section(section) 
  entry = {}
  section.each_line do |line|
    line.sub! /^(\w\w)\s+/,""
    if  entry[$1].nil?
      entry[$1] = line
    else
      entry[$1] = entry[$1] + line
    end
  end
  entry["CC"].sub! /-----------.+---------/m,""
  entry["CC"].split("-!- ").each do |c|
    c.sub! /^((?:\w|\s)+):\s+/,""
    entry[$1] = c
  end
  entry.delete "CC"
  entry
end


all_diseases = []

file.each_line("\n//\n") do |section|
  entry = parse_section section

  #p entry.to_yaml
  unless  entry["DISEASE"].nil?
    matches = entry["DISEASE"] =~ /cause of (.+?) \(/m
    disease = $1
    disease.gsub!( /\n/, " ") unless disease.nil?
    all_diseases << disease unless disease.nil?
  end

end

uniq_diseases = all_diseases.uniq

File.open "uniprot_diseases.txt","w" do |f|
  f.print uniq_diseases.sort * "\n"
end

print "#{all_diseases.size}\t#{uniq_diseases.size}\n"

