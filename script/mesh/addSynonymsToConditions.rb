require 'yaml'
require 'progressbar'

DEBUG = true

file_path = ARGV[0]
file = File.new(file_path, 'r')

mesh_synonyms = YAML.load(file)

progress = ProgressBar.new("Parsing MESH",mesh_synonyms.size)

allResults = []
added = 0
mesh_synonyms.each_pair do |key, synonyms|
  added += 1
  progress.inc
  synonyms << key

  if DEBUG
    break if added > 1000
  end

  results = {}
  synonyms.each do |syn| 
    condition = Condition.search(syn).first
    unless condition.nil? 
      name = condition.name
      results[name] ||= 0
      results[name] += 1
    end 
  end

  next if results.empty?

  allResults << [synonyms,results]
end

progress.finish
print allResults.to_yaml

