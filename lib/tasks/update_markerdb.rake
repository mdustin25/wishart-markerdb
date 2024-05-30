# coding: utf-8
require 'biosummarizer'
require 'uri'
require 'json'
require 'string/similarity'
namespace :update_markerdb do
	desc "update tables based on tsv file"
	# 1st column: Model name (i.e.,g Chemical, Concentration, RocStats, etc)
	# 2nd column: Id of the entry to be updated
	# All subsequent columns are column names of corresponding model
	# # any cells with NA are ignored
	# # To set attribute to null, enter null
	# # e.g., row 2 updates only col 3 out of 5 cols then all except col 3 for row 2 is blank
  task :from_tsv, [:info_file,:out_file] => [:environment] do |t,args|
    in_file = args[:info_file]
    log = File.open(args[:out_file],'w')
    in_ptr = File.open(in_file,'r')
    in_cont = in_ptr.readlines()
    header = in_cont.shift()
    header = header.split("\t")
    header = header.map{|h| h.strip()}
    klass = header.shift().constantize
    id = header.shift()
    klass.transaction do
      in_cont.each do |line|
        line = line.strip()
        line_elem = line.split("\t")
        line_elem = line_elem.map{|l| l.strip()}
        klass = line_elem.shift().constantize
        id = line_elem.shift()
        if line_elem.length == header.length
          obj = klass.find(id)
          update_hash = Hash.new
          ctr = 0
          # ignores any blank fields
          while(ctr < header.length)
          	value = line_elem[ctr].strip()
            unless value == "NA"
              # if the header is exported convert 0,1 to true false
              if header[ctr] == "exported"
                if value == "0"
                  update_hash[header[ctr]] = false
                elsif value == "1"
                  update_hash[header[ctr]] = true
                elsif value == "null"
                 	update_hash[header[ctr]] = nil
                end             
              else
              	# change any value null to actual null
              	if value == "null"
                	update_hash[header[ctr]] = nil
                else
                	update_hash[header[ctr]] = value.strip()
                end
              end
            end
            ctr += 1
          end
          # puts("#{id} #{update_hash}")
          unless update_hash.keys.empty?
	          obj.update!(update_hash)
	          log.write("#{id}\t#{update_hash}\n")
	        end
        end
      end
    end
  end
	desc "generate summary stats for front page/about us page"
	def biomarker_category_count(category_id)
		# obtain category count by looking through
		# # Chemicals (Concentration)
		# # Proteins (Concentration)
		# # Karyotypes (KaryotypeIndication)
		# # Genetic (Seq var and SNP)
		res_hash = Hash.new
		chemical_conc_count = ActiveRecord::Base.connection.exec_query("select distinct ch.id from concentrations c, chemicals ch where c.solute_type = \"Chemical\" and c.solute_id = ch.id and c.exported = true and ch.exported = true and c.biomarker_category_id = #{category_id} and c.condition_id not in (#{Condition.not_abnormal_condition_ids.join(",")})")
		# protein count
		prot_conc_count = ActiveRecord::Base.connection.exec_query("select distinct p.id from concentrations c, proteins p where c.solute_type = \"Protein\" and c.solute_id = p.id and c.exported = true and p.exported = true and c.biomarker_category_id = #{category_id} and c.condition_id not in (#{Condition.not_abnormal_condition_ids.join(",")})")
		# count for karyotype
		all_karyotype_count = ActiveRecord::Base.connection.exec_query("select distinct k.id from karyotypes k, karyotype_indications ki where ki.karyotype_id = k.id and ki.biomarker_category_id = #{category_id} and ki.condition_id not in (#{Condition.not_abnormal_condition_ids.join(",")})")
		# count for seq var
		# all_seqvar_count = ActiveRecord::Base.connection.exec_query("select distinct sv.id from genes g, sequence_variant_measurements svm, sequence_variants sv where sv.id = svm.sequence_variant_id and sv.gene_id = g.id and g.exported = true and svm.biomarker_category_id = #{category_id} and svm.condition_id not in (#{Condition.not_abnormal_condition_ids.join(",")})").rows.length
		all_seqvar_count = ActiveRecord::Base.connection.exec_query("select distinct sv.id from sequence_variant_measurements svm, sequence_variants sv where sv.exported=true and sv.id = svm.sequence_variant_id and svm.biomarker_category_id = #{category_id} and svm.condition_id not in (#{Condition.not_abnormal_condition_ids.join(",")})")
		# storing return values
		res_hash[:chem_count] = chemical_conc_count
		res_hash[:prot_count] = prot_conc_count
		res_hash[:karyo_count] = all_karyotype_count
		res_hash[:seqvar_count] = all_seqvar_count
		return res_hash
	end

	task :summary_stats => [:environment] do |t|
		# Path to file storing the summary stats
		download_path = "public/system/summary_stats/current"
		Dir.mkdir("public/system/summary_stats/") unless File.exists?("public/system/summary_stats/")
		Dir.mkdir(download_path) unless File.exists?(download_path)
		

		# done for all categories and store in separate files
		CATEGORIES_ID_HASH = {"diagnostic"=>2,"prognostic"=>3, "predictive"=>1,"exposure"=>4}
		# Get count of DIAGNOSTIC markers
		diagnostic_res_hash = biomarker_category_count(CATEGORIES_ID_HASH["diagnostic"])
		# Get count of PROGNOSTIC markers
		prognostic_res_hash = biomarker_category_count(CATEGORIES_ID_HASH["prognostic"])
		# Get count of PREDICTIVE markers
		predictive_res_hash = biomarker_category_count(CATEGORIES_ID_HASH["predictive"])
		# Get count of EXPOSURE markers
		exposure_res_hash = biomarker_category_count(CATEGORIES_ID_HASH["exposure"])
		# Get count for all biomarkers regardless of biomarker categories
		all_biomarker_hash = [*diagnostic_res_hash,*prognostic_res_hash,*predictive_res_hash,*exposure_res_hash].to_h
		# Use a timestamped name so we don't delete the current file until this one is done
		current_time = Time.now.to_i
		time_path = File.join(download_path,"summary_stats-#{current_time}.tsv")
		file_path = time_path.gsub("-#{current_time}", "")
		out_file = File.open(time_path,'w')
		
		# diagnostic markers:
		all_diagnostic_markers = 0
		diagnostic_res_hash.each do |k,v|
			all_diagnostic_markers += v.rows.length
		end
		out_file.write("diagnostic\t#{all_diagnostic_markers}\n")

		# prognostic markers:
		all_prognostic_markers = 0
		prognostic_res_hash.each do |k,v|
			all_prognostic_markers += v.rows.length
		end
		out_file.write("prognostic\t#{all_prognostic_markers}\n")

		# predictive markers:
		all_predictive_markers = 0
		predictive_res_hash.each do |k,v|
			all_predictive_markers += v.rows.length
		end
		out_file.write("predictive\t#{all_predictive_markers}\n")

		# exposure markers:
		all_exposure_markers = 0
		exposure_res_hash.each do |k,v|
			all_exposure_markers += v.rows.length
		end
		out_file.write("exposure\t#{all_exposure_markers}\n")
		# all biomarker counts
		all_chem_markers = 0
		all_chem_marker_array = Array.new
		diagnostic_res_hash[:chem_count].each do |dia_chem|
			unless all_chem_marker_array.include?(dia_chem)
				all_chem_markers += 1
				all_chem_marker_array << dia_chem
			end
		end 
		predictive_res_hash[:chem_count].each do |pred_chem|
			unless all_chem_marker_array.include?(pred_chem)
				all_chem_markers += 1
				all_chem_marker_array << pred_chem
			end
		end
		prognostic_res_hash[:chem_count].each do |prog_chem|
			unless all_chem_marker_array.include?(prog_chem)
				all_chem_markers += 1
				all_chem_marker_array << prog_chem
			end
		end
		exposure_res_hash[:chem_count].each do |exp_chem|
			unless all_chem_marker_array.include?(exp_chem)
				all_chem_markers += 1
				all_chem_marker_array << exp_chem
			end
		end

		all_prot_markers = 0
		all_prot_marker_array = Array.new
		diagnostic_res_hash[:prot_count].each do |dia_prot|
			unless all_prot_marker_array.include?(dia_prot)
				all_prot_markers += 1
				all_prot_marker_array << dia_prot
			end
		end 
		predictive_res_hash[:prot_count].each do |pred_prot|
			unless all_prot_marker_array.include?(pred_prot)
				all_prot_markers += 1
				all_prot_marker_array << pred_prot
			end
		end
		prognostic_res_hash[:prot_count].each do |prog_prot|
			unless all_prot_marker_array.include?(prog_prot)
				all_prot_markers += 1
				all_prot_marker_array << prog_prot
			end
		end
		exposure_res_hash[:prot_count].each do |exp_prot|
			unless all_prot_marker_array.include?(exp_prot)
				all_prot_markers += 1
				all_prot_marker_array << exp_prot
			end
		end
												
												
		
		all_seqvar_markers = 0
		all_seqvar_marker_array = Array.new
		diagnostic_res_hash[:seqvar_count].each do |dia_seqvar|
			unless all_seqvar_marker_array.include?(dia_seqvar)
				all_seqvar_markers += 1
				all_seqvar_marker_array << dia_seqvar
			end
		end 
		predictive_res_hash[:seqvar_count].each do |pred_seqvar|
			unless all_seqvar_marker_array.include?(pred_seqvar)
				all_seqvar_markers += 1
				all_seqvar_marker_array << pred_seqvar
			end
		end
		prognostic_res_hash[:seqvar_count].each do |prog_seqvar|
			unless all_seqvar_marker_array.include?(prog_seqvar)
				all_seqvar_markers += 1
				all_seqvar_marker_array << prog_seqvar
			end
		end
		exposure_res_hash[:seqvar_count].each do |exp_seqvar|
			unless all_seqvar_marker_array.include?(exp_seqvar)
				all_seqvar_markers += 1
				all_seqvar_marker_array << exp_seqvar
			end
		end
												
		all_karyo_markers = 0
		all_karyo_marker_array = Array.new
		diagnostic_res_hash[:karyo_count].each do |dia_karyo|
			unless all_karyo_marker_array.include?(dia_karyo)
				all_karyo_markers += 1
				all_karyo_marker_array << dia_karyo
			end
		end 
		predictive_res_hash[:karyo_count].each do |pred_karyo|
			unless all_karyo_marker_array.include?(pred_karyo)
				all_karyo_markers += 1
				all_karyo_marker_array << pred_karyo
			end
		end
		prognostic_res_hash[:karyo_count].each do |prog_karyo|
			unless all_karyo_marker_array.include?(prog_karyo)
				all_karyo_markers += 1
				all_karyo_marker_array << prog_karyo
			end
		end
		exposure_res_hash[:karyo_count].each do |exp_karyo|
			unless all_karyo_marker_array.include?(exp_karyo)
				all_karyo_markers += 1
				all_karyo_marker_array << exp_karyo
			end
		end
		
		out_file.write("chemical\t#{all_chem_markers}\n")
		out_file.write("protein\t#{all_prot_markers}\n")
		out_file.write("seqvar\t#{all_seqvar_markers}\n")
		out_file.write("karyo\t#{all_karyo_markers}\n")
		all_conditions = Condition.super_conditions.where("id not in (?)",Condition.not_abnormal_condition_ids.uniq).length
		out_file.write("condition\t#{all_conditions}\n")
		out_file.close()
		# Remove existing file (if it exists)
		File.delete(file_path) if File.exists?(file_path)
		# Rename the timestamped file
		File.rename(time_path, file_path)
	end

	desc "Run biosummarizer based on txt file -> 1 id per line."
	task :run_biosummarizer_from_tsv, [:tsv] => [:environment] do |t, args|
		MarkerDB::Alias
		MarkerDB::Gene
		ptr = File.open(args[:tsv])
		cont = ptr.readlines()
		cont.each do |each_id|
			protein = Protein.find(each_id.strip)
			puts("working on #{each_id} #{protein.name}")
			unless protein.gene_name.nil? and protein.uniprot_id.nil?
				protein_data = {'organism' => "Homo Sapiens",
											'symbol_verbatim' => 'true'}
				if !protein.uniprot_id.nil?
					protein_data["uniprot_id"] = protein.uniprot_id
				end
				if !protein.gene_name.nil?
					protein_data["symbol"] = protein.gene_name
				end
				summary = BioSummarizer::summarize(protein_data)
				puts(protein.gene_name)
				puts(summary)
				STDIN.gets()
				if !summary.nil?
					gene = Gene.where(:gene_symbol => protein.gene_name).first
					unless gene.nil?
						gene.biosummarizer_description = summary["Description"] if summary["Description"]
						gene.fasta = summary['FASTA'] if summary['FASTA']
						if summary["Protein Name"]
							gene.name = summary["Protein Name"].gsub("\"","")
							gene.aliases.where(name: summary["Protein Name"]).delete_all
						end
						gene.save!
					end
					if !summary["Protein Name"].nil?
						begin
							if protein.aliases.where(name: protein.name).empty?
								protein.aliases.create(name: protein.name)
							end
						rescue Exception => e 
							puts "Protein Alias exists"
						end
						# protein.name = summary["Protein Name"].gsub("\"","")
						if protein.aliases.where(name: summary["Protein Name"]).first.nil?
							prot_alias = protein.aliases.build(
								name: summary["Protein Name"])
							prot_alias.save!
						end
					end
					
					unless summary["Description"].nil?
						if protein.description.nil?
							protein.description = summary["Description"]
						end
					end
					unless summary["PPS"].nil? 
						pps = summary["PPS"].split("\n")
						header = pps.shift()
						pps = pps.join("")
						# protein.protein_sequence = pps
						if Sequence.where("sequenceable_type = \"PolypeptideSequence\" and sequenceable_id = ?",protein.id).blank?
							prot_prot_seq = protein.create_polypeptide_sequence(header: "#{protein.name}_protein",
																					chain: pps)
							prot_prot_seq.save!
						end
					end
					unless summary["FASTA"].nil?
						fasta = summary["FASTA"].split("\n")
						header = fasta.shift()
						fasta = fasta.join("")
						if Sequence.where("sequenceable_type = \"GeneSequence\" and sequenceable_id = ?",protein.id).blank?
							prot_gene_seq = protein.create_gene_sequence(header: "#{protein.name}_gene",
																					chain: fasta)
							prot_gene_seq.save!
						end
					end
					protein.save!
				end
			end
		end
	end
	
	desc "Run Biosummarizer on all genes"
	task :run_biosummarizer=>[:environment] do |t|
		MarkerDB::Alias
		MarkerDB::Gene
		#MarkerDB::Protein
		Gene.find_in_batches(batch_size: 8) do |group|
			group.each do |gene|
				begin
					symbol = gene.gene_symbol
					next if gene.gene_symbol.nil? or gene.biosummarizer_description.present?
					protein_data = {'symbol' => symbol,
												'organism' => "Homo Sapiens",
												'uniprot_id' => nil,
												'symbol_verbatim' => 'true'}
					summary = BioSummarizer::summarize(protein_data)
					if !summary.nil?
						puts summary["Protein Name"]
						puts summary['FASTA']
						puts summary["PPS"]
						puts summary["Description"]
						gene.biosummarizer_description = summary["Description"] if summary["Description"]
						gene.fasta = summary['FASTA'] if summary['FASTA']
						if summary["Protein Name"]
							# begin
							#   if gene.aliases.where(name: gene_name).empty?
							#     gene.aliases.create(name: gene.name)
							#   end
							# rescue Exception => e 
							#   puts "Gene Alias exists"
							# end
							gene.name = summary["Protein Name"].gsub("\"","")
							gene.aliases.where(name: summary["Protein Name"]).delete_all
						end
						protein = Protein.where(gene_name: symbol).first()
						if protein
							if !summary["Protein Name"].nil?
								begin
									if protein.aliases.where(name: protein.name).empty?
										protein.aliases.create(name: protein.name)
									end
								rescue Exception => e 
									puts "Protein Alias exists"
								end
								protein.name = summary["Protein Name"].gsub("\"","")
								protein.aliases.where(name: summary["Protein Name"]).delete_all
							end
							unless summary["PPS"].nil? 
								pps = summary["PPS"].split("\n")
								header = pps.shift()
								pps = pps.join("")
								# protein.protein_sequence = pps
								if Sequence.where("sequenceable_type = \"PolypeptideSequence\" and sequenceable_id = ?",protein.id).blank?
									prot_prot_seq = protein.create_polypeptide_sequence(header: "#{protein.name}_protein",
																							chain: pps)
									prot_prot_seq.save!
								end
							end
							unless summary["FASTA"].nil?
								fasta = summary["FASTA"].split("\n")
								header = fasta.shift()
								fasta = fasta.join("")
								if Sequence.where("sequenceable_type = \"GeneSequence\" and sequenceable_id = ?",protein.id).blank?
									prot_gene_seq = protein.create_gene_sequence(header: "#{protein.name}_gene",
																							chain: fasta)
									prot_gene_seq.save!
								end
							end
						# else
						#   protein = Protein.new(
						#     name: summary["Protein Name"],
						#     description: summary["Description"],
						#     gene_name: summary["Gene Name"],
						#     uniprot_id: summary["Uniprot_ID"],
						#     protein_sequence: summary["PPS"],
						#     exported: true
						#   )
						protein.save!
						end
						
						gene.save!
					end
				rescue Exception => e
					puts "Exception Raised"
				end
			end
		end
	end


	def numbers_match(a,b)
		if a.split.map {|x| x[/\d+/]} == b.split.map {|x| x[/\d+/]}
			return roman_numerals(a,b)
		else
			return false
		end
	end

	def roman_numerals(a,b)
		a = a + " "
		b = b + " "
		[" i "," ii "," iii ", " iv "," v "," vi "," vii "," viii ", " ix ", " x ", " xi ", " xii "].each do |num|
			if a.include? num
				if b.include? num
					return true
				else
					return false
				end
			end
		end
		return true
	end

	desc "Consolidate ChemFOnt"
	task :consolidate_chemfont => [:environment] do |t,args|
		aggr_conditions = []
		conditions = Condition.super_conditions.select("id, name, description")
		conditions.each do |condition|
			cond = {id: nil, name: nil, description: nil}
			next if condition.name.downcase.include? "exposure"
			cond[:id] = condition.id
			cond[:name] = condition.name
			cond[:description] = condition.description
			next if (cond[:name].include? "Consumption") || (cond[:name].include? "Exposure")
			aggr_conditions.push(cond)
		end
		puts aggr_conditions.length
		total = 0
		CSV.foreach('health_effects.csv', headers: true) do |row| 
			term = row['TERM'].strip()
			synonyms = row['EXACT SYNONYMS'].split(';') if row['EXACT SYNONYMS']
			matched = nil
			aggr_conditions.each do |aggr_cond|
				if String::Similarity.levenshtein(aggr_cond[:name].gsub(" ","").downcase, term.gsub(" ","").strip().downcase) > 0.85 && numbers_match(aggr_cond[:name].downcase, term.downcase)
					puts  "First " + aggr_cond[:name].downcase + " is " + String::Similarity.levenshtein(aggr_cond[:name].downcase, term.downcase).to_s + " similar to " + term.downcase
					matched = aggr_cond
				elsif synonyms
					synonyms.each do |syn|
						matched = aggr_cond if (String::Similarity.levenshtein(aggr_cond[:name].gsub(" ","").downcase,syn.gsub(" ","").downcase)) > 0.85 && (numbers_match(aggr_cond[:name].downcase, syn.downcase))
						if matched
							puts "Second " + aggr_cond[:name].downcase + " is " + String::Similarity.levenshtein(aggr_cond[:name].downcase,syn.strip().downcase).to_s + " similar to " + syn.downcase
						end
						break if matched
					end
				end
				break if matched
			end
			if matched
				aggr_conditions.delete(matched)
				condition = Condition.find(matched[:id])
				#puts "#{matched[:name]} ==-== #{term} #{synonyms}"
				#puts term
				total += 1
				#puts row['DEFINITION']
				condition.description = row['DEFINITION'] if row['DEFINITION'] && condition.description.nil?
				condition.save!	
			end
		end
		print total
	end



	desc "Fix condition name"
	task :fix_name => [:environment] do |t|
		Condition.each do |cond|
			cond.name = cond.name.gsub("\"","")
			cond.save!
		end
	end

	desc "update exported status for concentrations, chemicals, proteins, genes"
	task :export_biomarkers => [:environment] do |t|
		puts("exporting proteins")
		Rake::Task["protein:export_prot"].invoke()
		puts("exporting genes")
		Rake::Task["sequence_variant:export_seqvar"].invoke()
		puts("exporting chemicals")
		Rake::Task["chemical:export_chem"].invoke()
	end

	def obtain_mdb_id(ctr)
		marker_mdbid = "MDB#{ctr.to_s.rjust(8,"0")}"
		return marker_mdbid
	end

	desc "add mdbid to all markers and conditions for those that are missing it"
	# rake update_markerdb:add_mdbid
	task :add_mdbid => [:environment] do |t|
		# this is the largest possible id
		max_possible_id = 99999999
		
		# obtain the largest id so far
		# if max_mdbid is nil then there are no mdbid right now.
		max_mdbid = MarkerMdbid.all.order(mdbid: :desc).first
		if max_mdbid.nil?
			next_id = 1
		else
			max_mdbid = max_mdbid.mdbid
			max_mdbid = max_mdbid.sub(/^MDB/,"").to_i
			# if next_id is 1 more than the current one
			next_id = max_mdbid + 1
		end

		Chemical.transaction do
			all_chem = Chemical.where("exported = true and id not in (?)",MarkerMdbid.where("identifiable_type = \"Chemical\"").select(:identifiable_id))
			puts "got all chemicals"
			all_chem.each do |each_chem|
				# if the next id is too big, we quit
				if next_id > max_possible_id
					raise RuntimeError.new("maxed out all id, nothing saved! Reformat all MDBID is needed! Largest possible now is #{max_possible_id}.")
				else
					# if it is not too big, we store it and increment it
					formatted_next_id = obtain_mdb_id(next_id)
					puts "creating mdbid"
					each_chem.create_marker_mdbid(mdbid: formatted_next_id)
					next_id += 1
				end
			end
			all_prot = Protein.where("exported = true and id not in (?)",MarkerMdbid.where("identifiable_type = \"Protein\"").select(:identifiable_id))
			all_prot.each do |each_prot|
				# if the next id is too big, we quit
				if next_id > max_possible_id
					raise RuntimeError.new("maxed out all id, nothing saved! Reformat all MDBID is needed! Largest possible now is #{max_possible_id}.")
				else
					# if it is not too big, we store it and increment it
					formatted_next_id = obtain_mdb_id(next_id)
					each_prot.create_marker_mdbid(mdbid: formatted_next_id)
					next_id += 1
				end
			end
			all_genes = SequenceVariant.where("exported = true and id not in (?)",MarkerMdbid.where("identifiable_type = \"Variant\"").select(:identifiable_id))
			all_genes.each do |each_gene|
				# if the next id is too big, we quit
				if next_id > max_possible_id
					raise RuntimeError.new("maxed out all id, nothing saved! Reformat all MDBID is needed! Largest possible now is #{max_possible_id}.")
				else
					# if it is not too big, we store it and increment it
					formatted_next_id = obtain_mdb_id(next_id)
					each_gene.create_marker_mdbid(mdbid: formatted_next_id)
					next_id += 1
				end
			end
			all_karyotype = Karyotype.where("id not in (?)",MarkerMdbid.where("identifiable_type = \"Karyotype\"").select(:identifiable_id))
			all_karyotype.each do |each_karyo|
				# if the next id is too big, we quit
				if next_id > max_possible_id
					raise RuntimeError.new("maxed out all id, nothing saved! Reformat all MDBID is needed! Largest possible now is #{max_possible_id}.")
				else
					# if it is not too big, we store it and increment it
					formatted_next_id = obtain_mdb_id(next_id)
					each_karyo.create_marker_mdbid(mdbid: formatted_next_id)
					next_id += 1
				end
			end
		end
	end


	def get_type(omim)
		list = ["neurodegenerative", "neurodevelopmental", "developmental", "inborn error of metabolism", 
				"neurologic", "neurological", "liver disorder", "cardiac disorder", "kidney disorder", "skin disorder", "digestive disorder", "gynecologic"]
		for item in list
			if omim.downcase().include? item
				return item
			end
		end
		return nil
	end

	def genetic_hetero(omim)
		if (omim.downcase.include? "genetic heterogeneity") || (omim.downcase.include? "genetically heterogeneous") || (omim.downcase.include? "various genetic")
			return true
		else
			return false
		end
	end

	def get_inheritance(omim)
		omim = omim.downcase.gsub("-","")
		ar = omim.count("autosomal recessive")
		ad = omim.count("autosomal dominant")
		xr = omim.count('x linked recessive')
		xd = omim.count('x linked dominant')
		y = omim.count("y linked")
		if ar > ad && ar > xr  && ar > xd && ar > y
			return "autosomal recessive"
		elsif ad > ar && ad > xr  && ad > xd && ad > y
			return "autosomal dominant"
		elsif xr > ar && xr > ad  && xr > xd && xr > y
			return "x-linked recessive"
		elsif xd > ar && xd > ad  && xd > xr && xd > y
			return "x-linked dominant"
		elsif y > ar && y > ad  && y > xr && y > xd
			return "y\-linked"
		else
			return nil
		end
	end

	def get_symptoms(omim, health_effects)
		omim = omim.downcase()
		symptoms = []
		health_effects.each do |effect|
			term = effect[0]
			synonyms = effect[1]
			if omim.include? term.downcase
				symptoms.push(term.downcase)
			elsif synonyms
				syn_in = false
				for synonym in synonyms
					next if (synonym.nil?) || (synonym == " " || synonym.length < 5)
					if omim.include? synonym.downcase.strip()
						#puts "#{term} + #{synonym.downcase.strip()}"
						syn_in = true
					end
				end
				symptoms.push(term.downcase) if syn_in
			end
		end
		return symptoms
	end

	def make_description (cond,type,gh,inheritance,symptoms)
		if type and gh
			if symptoms.any?
				puts "#{cond} is a genetically heterogenous #{type}#{(type.include? 'disorder') ? "" : " disorder"} which is linked to #{symptoms.to_sentence}."
				return "#{cond} is a genetically heterogenous #{type}#{(type.include? 'disorder') ? "" : " disorder"} which is linked to #{symptoms.to_sentence}."
			else
				puts "#{cond} is a genetically heterogenous #{type}#{(type.include? 'disorder') ? "" : " disorder"}."
				return "#{cond} is a genetically heterogenous #{type}#{(type.include? 'disorder') ? "" : " disorder"}."
			end
		elsif type and !gh and inheritance
			if symptoms.any?
				puts "#{cond} is an #{inheritance} #{type}#{(type.include? 'disorder') ? "" : " disorder"} which is linked to #{symptoms.to_sentence}."
				return "#{cond} is an #{inheritance} #{type}#{(type.include? 'disorder') ? "" : " disorder"} which is linked to #{symptoms.to_sentence}."
			else
				puts "#{cond} is an #{inheritance} #{type}#{(type.include? 'disorder') ? "" : " disorder"}."
				return "#{cond} is an #{inheritance} #{type}#{(type.include? 'disorder') ? "" : " disorder"}."
			end
		elsif !type and gh 
			if symptoms.any?
				puts "#{cond} is a genetically heterogenous disorder which is linked to #{symptoms.to_sentence}."
				return "#{cond} is a genetically heterogenous disorder which is linked to #{symptoms.to_sentence}."
			else
				puts "#{cond} is a genetically heterogenous disorder."
				return "#{cond} is a genetically heterogenous disorder."
			end
		elsif !type and inheritance
			if symptoms.any?
				puts "#{cond} is an #{inheritance} disorder which is linked to #{symptoms.to_sentence}."
				return "#{cond} is an #{inheritance} disorder which is linked to #{symptoms.to_sentence}."
			else
				puts "#{cond} is a genetically heterogenous disorder."
				return "#{cond} is an #{inheritance} disorder."
			end
		end
		return nil
	end
				

	desc "Use OMIM descriptions to generate condition descriptions"
	task :generate_condition_descriptions => [:environment] do |t|
		conditions = Condition.exported
		conditions_omim = []
		conditions.each do |cond|
			next if cond.description.present?
			id = cond.id
			name = cond.name
			extra = ExtraDescription.where("describable_id = ? and describable_type = ? ",id,"Condition")
			next if extra.first.nil?
			conditions_omim.push([id,name,extra.first.description])
		end
		health_effects = []
		CSV.foreach('health_effects.csv', headers: true) do |row| 
			term = row['TERM'].strip()
			synonyms = row['EXACT SYNONYMS'].split(';') if row['EXACT SYNONYMS']
			health_effects.push([term,synonyms])
		end
		count = 0
		conditions_omim.each do |river|
			cond_id = river[0]
			cond_name = river[1]
			omim = river[2].downcase
			type = get_type(omim)
			genetic_heterogeniety = genetic_hetero(omim)
			inheritance = get_inheritance(omim)
			symptoms = get_symptoms(omim,health_effects)
			description = make_description(cond_name,type,genetic_heterogeniety,inheritance,symptoms)
			count += 1 if description
			description = nil
			#puts omim
		end
		puts count
	end
end


	# desc "Get OMIM ID's for all condtions"
	# task :get_omim => [:environment] do |t|
	# end

