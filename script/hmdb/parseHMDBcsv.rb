# this is a script for reading from HMDB mysql database
# and inputing the relevant information into our db
#require 'mysql2'
require 'csv'

file_path = ARGV[0]
added = 0

#con = Mysql2::Client.new(:host=>'localhost',:username=>'ronghong',:password=>'nomore04',:database=>'labm')
#rs = con.query "select a.id as chem_id, 
#	access_id,
#	common_name,
#	description,
#	a.synonyms as chem_synonyms,
#	iupac,
#	chemical_formula,
#	syn_refs,
#	cell_loc,
#	tissue_loc,
#	source,
#	biofluid_page,
#	patient_status,
#	conc_condition,
#	biofluid_source,
#	conc_value,
#	conc_unit,
#	age,
#	sex,
#	reference,
#	c.comment as conc_comment,
#	c.export_comment as conc_export_comment,
#	d.name as disease_name,
#	d.synonyms as disease_synonyms,
#	omim_id,
#	metagene_id 
#	from labm.tbl_chemical a ,
#	labm.tbl_concentrations c,
#	labm.tbl_concentrations_disease j,
#	labm.tbl_disease d 
#	where c.id = j.concentrations_id 
#	AND d.id = j.disease_id 
#	and a.id=c.parent_id and a.export_hmdb = 'Yes' 
#	and c.export_hmdb = 'Yes'"
#
#rs.each do |row|
CSV.foreach(file_path, :headers => true) do |row|

  bm = MoleculeBm.find_or_create_by_name(row["common_name"])
  bm.attributes = {
    :name => row["common_name"],
    :description => row["description"],
    :iupac => row["iupac"],
    :hmdb => row["id"],
  }
  bm.save

  # add the aliases
  unless row["chem_synonyms"].nil? 
    aliases =  row["chem_synonyms"].split(";")
    aliases.each do |a|
      unless a.empty? or (a =~ /null/i ) or (a =~ /^\s+$/) 
        bm.molecule_bm_aliases.find_or_create_by_name(a)
      end
    end
  end


  name =  row["disease_name"]
  cond = Condition.find_or_create_by_name name
  
  # add the aliases
  disease_synonyms = row["disease_synonyms"]
  unless disease_synonyms.nil? or disease_synonyms.empty?
    aliases =  disease_synonyms.split(";")
    aliases.each do |a|
      if (not a.empty?) and (not a.nil? ) and (a !~ /^\s+$/) 
        cond.condition_aliases.find_or_create_by_name(a)
      end
    end
  end

  level = MoleculeLevel.new({
    :level => "#{row["conc_value"]} #{row["conc_unit"]}",
    :location_name => row["source"],
    :sex =>  row["sex"],
    :age_range => row["age"],
    :biofluid => row["biofluid_source"]
  })
  level.condition = cond
  level.molecule_bm = bm
  level.comment = row["conc_comment"] if row["conc_export_comment"] == 'Yes'
  level.save

  if not (row["reference"].nil? or row["reference"].empty? ) 
    refs = row["reference"].split(";")
    refs.each do |text|
      new_ref = level.references.new
      if text =~ /(\d{5,10})/
        new_ref.pubmed_id = $1
      else 
        new_ref.citation = text
      end 
      new_ref.save
    end
  end                    

  added = added + 1
  break if added > 10 
end

puts "added #{added} entries"

