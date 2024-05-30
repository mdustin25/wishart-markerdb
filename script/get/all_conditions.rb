# script to output all the conditions

out = File.open("all_conditions.csv","w")

out.print "name\taliases\tcategories\n"

Condition.all.each do |c|

  row = [ 
    c.name, 
    c.aliases.map {|x| x.name.strip} * "; ",
    c.categories.map{|x| x.name} * "; ", 
  ]

  out.print row * "\t"
  out.print "\n"

end
