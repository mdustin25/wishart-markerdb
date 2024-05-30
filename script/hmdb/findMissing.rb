require './script/hmdb/hmdb_util'
require 'set'

file_path = ARGV[0]
raise "No file given" if file_path.nil?

db_names  =  MoleculeBm.all.collect do |bm|
  bm.name.strip
end
db_names = Set.new(db_names)
  
card_names = Set.new 
total = 0

load_cards_from_yaml file_path do |card|
  name = card["name"].first
  card_names << name
  total += 1
end


print "Missing:\n\t"
print (db_names - card_names).to_a * "\n\t"
print "\n"


