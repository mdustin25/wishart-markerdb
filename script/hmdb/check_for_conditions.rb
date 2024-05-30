require './script/hmdb/hmdb_util'

file_path = ARGV[0]
raise "No file given" if file_path.nil?


load_cards_from_yaml file_path do |card|
  card.associated_disorders.each do |disorder|
    next if disorder.nil?
    condition = Condition.find_by_name disorder.name
    if condition.nil?
      print "#{disorder.name}\n"
    end
  end
end
 
