refs = YAML::load File.open("data/updated_references.yaml", "r")
columns = refs.first.keys

# need to remove these columns otherwise duplicates
# are added
columns.delete "created_at"
columns.delete "updated_at"

values  = []
refs.each do |ref|
  ref_values = []
  columns.each do |col|
    ref_values << ref[col]
  end
  values << ref_values
end

columns.map!{|col| col.to_sym}

# we want to update all columns
Reference.import columns, values, :on_duplicate_key_update => columns.dup, :validate => false, :timestamps => false 

