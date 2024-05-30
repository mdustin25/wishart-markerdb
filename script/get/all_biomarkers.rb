# script to print out info about all the biomarkers in 
# tab delimited file

# touch a model so rails loads them
GeneticBm.new

# types of biomarkers
types = Class.constants.grep(/Bm$/).map{|x| eval(x.to_s)}

# columns to print
cols = { 
  :bmid => nil,
  :name => nil,
  :aliases => lambda {|x| x.aliases.map{|x| x.name.strip}},
  :omim_id => nil,
  :hmdb => nil,
  :gene => nil
  #:conditions => lambda {|x| c = x.conditions.map{|c| c.name.strip}.uniq.sort; c.delete("Not Available");c}
}

out = File.new("all_markers.csv", "w")
# header 
out.puts cols.keys.map(&:to_s) * "\t" 

types.each do |type|
  type.all.each do |marker|
    row = []
    cols.each_pair do |col,func|
      begin 
        if func.nil?
          row << marker.send(col.to_sym).to_s.strip 
        else
          row << func.call(marker) * "; "
        end
      rescue NoMethodError => e
        row << ""
      end
    end 
    out.puts row * "\t"
  end
end

out.close
