# this is a script for parsing the metabocard
# flatfile from hmdb

require './script/hmdb/hmdb_util'
require 'yaml'

file_path = ARGV[0]

count = 0
total = 0

out = File.new("usefull_hmdb.yaml","w")

each_card(file_path) do |card|
  #id = card["hmdb_id"]
  unless card["concentration"].nil? and card["associated_disorder"].nil?
    count += 1
    out.print YAML.dump card
  end
  total += 1

end

print "total: #{total}\n"
print "conc : #{count}\n"

