# this is a script for parsing the metabocard
# flatfile from hmdb

require './script/hmdb/hmdb_util'

file_path = ARGV[0]

count = 0
total = 0

each_card(file_path) do |card|
  #id = card["hmdb_id"]
  unless card["concentration"].nil?
    count += 1
  end
  total += 1

end

print "total: #{total}"
print "conc : #{count}"

