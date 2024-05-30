namespace :references do 
	desc "add references from csv file"
	task :add_ref, [:csv_file] => [:environment] do |t,args|
		require 'csv'
		Reference.transaction do
			CSV.read(args[:csv_file],'r').each do |line|
				# there are no headers, columns are as follows (straight from pubmed export)
				# PMID,Title,Authors,Citation,First Author,Journal/Book,Publication Year,Create Date,PMCID,NIHMS ID,DOI
				ref = Reference.create!(
					title: line[1],
					citation: line[3],
					authors: line[2],
					year: line[6],
					pubmed_id: line[0]
					)
			end
		end
	end
	desc "add pubmed reference to concentration"
	task :add_pubmed_to_concentration, [:csv_file] => [:environment] do |t,args|
		require 'csv'
		CSV.read(args[:csv_file],'r').each do |row|
			conc_id, pubmed = row
			puts "concentration ID is " + conc_id.to_s
			pubmed_ids = pubmed.split(";")
			conc = Concentration.find_by(id: conc_id)
			if !conc.nil?
				pubmed_ids.each do |pubmed_id|
					puts "pubmed_id: " + pubmed_id.to_s
					ref_obj = Reference.where("pubmed_id = ?",pubmed_id).order(:id).first
					if ref_obj.nil?
					  ref_obj = Reference.new(
						pubmed_id: pubmed_id)
					  ref_obj.save!
					end
					citation_obj = conc.citations.build(
						reference_id: ref_obj.id)
					citation_obj.save!
					conc.save!
				end
			end
		end
	end


end