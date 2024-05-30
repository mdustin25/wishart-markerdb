namespace :add_biomarkers_conditions do 
	def link_extractor(disease_ref)
		potential_links = URI.extract(disease_ref)
		link = ""
		# check to see if it has links
		potential_links.each do |each_elem|
			if each_elem.include?("https") or each_elem.include?("http")
				link = each_elem.strip()
				break
			end
		end
		return link
	end
	def create_fetch_ref_obj(disease_ref)
		# tries to extract the link
		link = link_extractor(disease_ref)
		# check if it has links (in this case only 1 link)
		if link != ""
			disease_citation = disease_ref.sub(link,"").strip()
			# this file had some extra stripping to do
			disease_citation = disease_citation.sub("(MIC: )","")
			ref_obj = Reference.where("citation = ? and url = ?", disease_citation,link).first
			if ref_obj.nil?
				ref_obj = Reference.new(
					citation: disease_citation,
					url: link)
				ref_obj.save!
			end
		# check if it is pubmed id or not
		elsif disease_ref == disease_ref.to_i.to_s
			ref_obj = Reference.where("pubmed_id = ?",disease_ref).first
			if ref_obj.nil?
				ref_obj = Reference.new(
					pubmed_id: disease_ref)
				ref_obj.save!
			end
		# if not it is a textbook
		else
			ref_obj = Reference.where("citation = ?",disease_ref).first
			if ref_obj.nil?
				ref_obj = Reference.new(
					citation: disease_ref)
				ref_obj.save!
			end
		end
		return ref_obj
	end
	

	# chem_conc_hash has all the concentration info for 1 disease
	# roc_curve is either RocStats obj or nil
	# disease_normal is either disease or normal (for indexing)
	# chemical is the chemical that this concentration is for
	# disease_name = name of disease
	def create_concentration_obj(biofluid,chem_conc_hash,roc_curve,disease_normal,chemical,condition_id,disease_name)
		# if either min or max is missing, then will not have range
		chem_conc = chemical.concentrations.build(
				age_range: chem_conc_hash["#{disease_normal}_age_group"],
				units: chem_conc_hash["concentration_units"],
				pvalue: chem_conc_hash["p_value_2_show"],
				sex: chem_conc_hash["#{disease_normal}_gender_group"],
				biofluid: biofluid,
				condition_id: condition_id,
				biomarker_category_id: chem_conc_hash["biomarker_category_id"],
				indication_type_id: chem_conc_hash["indication_type_id"],
				exported: true)
		chem_conc.save!
		if chem_conc_hash.keys.include?("#{disease_normal}_concentration_min") and chem_conc_hash.keys.include?("#{disease_normal}_concentration_max")
			chem_conc.level = "#{chem_conc_hash["#{disease_normal}_concentration_mean"]} (#{chem_conc_hash["#{disease_normal}_concentration_min"]}-#{chem_conc_hash["#{disease_normal}_concentration_max"]}) #{chem_conc_hash["concentration_units"]}"
			chem_conc.range = "#{chem_conc_hash["#{disease_normal}_concentration_min"]}-#{chem_conc_hash["#{disease_normal}_concentration_max"]}"
		else
			chem_conc.level = "#{chem_conc_hash["#{disease_normal}_concentration_mean"]} #{chem_conc_hash["concentration_units"]}"
		end
		unless roc_curve.nil?
			chem_conc.quality_type = roc_curve.class
			chem_conc.quality_id = roc_curve.id
		end
		chem_conc.save!
		return chem_conc
	end

	def create_roc_curve_obj(disease_hash,roc_original_dir)
		roc_stat = RocStats.new(
										roc_auc: disease_hash["roc_mean_AUC"],
										sensitivity: disease_hash["roc_mean_sensitivity"],
										specificity: disease_hash["roc_mean_specificity"],
										image_file_name: disease_hash["roc_curve_filename"],
										image_content_type: "image/png",
										image_file_size: File.size(File.join(roc_original_dir,disease_hash["roc_curve_filename"]))
										)
		roc_stat.save!
		unless disease_hash.keys.include?("simplified_threshold")
			roc_stat.roc_conc_threshold = disease_hash["simplified_threshold"]
			roc_stat.save!
		end
		absolute_path = File.join(roc_original_dir,disease_hash["roc_curve_filename"])
		# this saves it automatically to /system/roc_stats/images/000/.../
		roc_stat.image = open(absolute_path)
		roc_stat.save!
		return roc_stat
	end
	def build_protein(marker_info,prot)
		# populate attribute bit by bit, since these are not manatory.
		if marker_info.keys.include?("gene_name")
			prot.gene_name = marker_info["gene_name"]
		end
		if marker_info.keys.include?("uniprot_id")
			prot.uniprot_id = marker_info["uniprot_id"]
		end
		if marker_info.keys.include?("uniprot_name")
			prot.uniprot_name = marker_info["uniprot_name"]
		end
		# Creates aa sequence associated with protein
		if marker_info.keys.include?("sequence")
			new_prot_sequence = prot.build_polypeptide_sequence(header: prot.name, chain: marker_info["sequence"])
			new_prot_sequence.save!
		end
		prot.save!
		return prot
	end
	def build_chemical(marker_info,chemical)
		if marker_info.keys.include?("hmdb")
			chemical.hmdb = marker_info["hmdb"]
		end
		if marker_info.keys.include?("panel_single")
			chemical.panel_single = marker_info["panel_single"]
		end
		chemical.save!
		return chemical
	end
	# returns a list of existing biomarkers -> so not to add duplicate (at least based on names)
	# will still add the roc curves/concentrations -> used for updating
	def obtain_existing_biomarkers()
		seen_biomarker = Hash.new
		all_prot = Protein.where("exported = true")
		all_prot.each do |each_prot|
			seen_biomarker["#{each_prot.name}-Protein"] = each_prot
		end
		all_chem = Chemical.where("exported = true")
		all_chem.each do |each_chem|
			seen_biomarker["#{each_chem.name}-Chemical"] = each_chem
		end
		return seen_biomarker
	end
	def save_novel_conditions(marker_info)
		condition = Condition.new(
			name: marker_info["name"],
			description: marker_info["description"],
			exported: true)
		condition.save!
		if marker_info.keys.include?("condition_category_id")
			cond_cat_ids = marker_info["condition_category_id"].split(";")
			cond_cat_ids.each do |each_cond_cat_id|
				ActiveRecord::Base.connection.execute("INSERT INTO condition_categories_conditions (condition_category_id, condition_id) VALUES (#{each_cond_cat_id}, #{condition.id});")
			end
		end
		return condition
	end
	def save_protein_chemicals_info(marker,marker_info)
		roc_curve_included = false
		if marker_info.keys.include?("roc_curve_filename")
			roc_original_dir = marker_info["roc_curve_directory"]
			roc_curve_included = true
			roc_stat = create_roc_curve_obj(marker_info,roc_original_dir)
		end
		if roc_curve_included
			disease_conc_obj = create_concentration_obj(marker_info["biofluid"],marker_info,roc_stat,"disease",marker,marker_info["condition_id"],marker_info["condition_name"])
		else
			disease_conc_obj = create_concentration_obj(marker_info["biofluid"],marker_info,nil,"disease",marker,marker_info["condition_id"],marker_info["condition_name"])
		end
		if marker_info.keys.include?("special_constraints")
			disease_conc_obj.special_constraints = marker_info["special_constraints"]
			disease_conc_obj.save!
		end
		if marker_info.keys.include?("status")
			disease_conc_obj.status = marker_info["status"]
			disease_conc_obj.save!
		end
		# obtain the reference entry, it will either be pubmed id or citation
		ref_obj = create_fetch_ref_obj(marker_info["disease_reference"].strip())
		# linking the citation to the concentration
		citation_obj = disease_conc_obj.citations.build(
			reference_id: ref_obj.id)
		citation_obj.save!
		# adding the normal values if this is new
		all_norm_conc = Concentration.where("solute_type = \"#{marker_info["marker_class"]}\" and exported = true and condition_id = 1")
		seen_norm_conc_array = Hash.new
		all_norm_conc.each do |each_norm|
			prot = each_norm.solute_type.constantize.where("id = ?",each_norm.solute_id).first
			unless prot.nil?
				seen_norm_conc_array["#{each_norm.solute_type.constantize}-#{prot.name}-#{each_norm.age_range}-#{each_norm.sex}-#{each_norm.biofluid}-#{each_norm.level})" ] = each_norm.id
			end
		end
		# will only assign reference_conc_id if it exists
		if marker_info.keys.include?("normal_concentration_mean")
			current_norm = "#{marker_info["marker_class"]}-#{marker_info["marker_name"]}-#{marker_info["normal_age_group"]}-#{marker_info["normal_gender_group"]}-#{marker_info["biofluid"]}-#{marker_info["normal_concentration_mean"]} (#{marker_info["normal_concentration_min"]}-#{marker_info["normal_concentration_max"]}) #{marker_info["concentration_units"]})" 
			unless seen_norm_conc_array.keys.include?(current_norm)
				normal_conc = create_concentration_obj(marker_info["biofluid"],marker_info,nil,"normal",marker,1,"normal")
				disease_conc_obj.reference_conc_id = normal_conc.id
				normal_conc.save!
				norm_ref = marker_info["normal_reference"].strip()
				ref_obj = create_fetch_ref_obj(norm_ref)
				# linking the citation to the concentration
				citation_obj = normal_conc.citations.build(
					reference_id: ref_obj.id)
				citation_obj.save!
				normal_conc.save!
			else
				disease_conc_obj.reference_conc_id = seen_norm_conc_array[current_norm]
			end
		end
		disease_conc_obj.save!
		return marker
	end
	# based on tsv file, store everything in hash
	def obtain_info_hash(line_elem,header)
		info_hash = Hash.new
		ctr = 0
		while (ctr < line_elem.length)
			value = line_elem[ctr].strip()
			if value != "NA"
				# if header is exported, convert 0,1 to true,false
				if header[ctr] == "exported"
					if value == "1"
						info_hash[header[ctr]] = true
					elsif value == "0"
						info_hash[header[ctr]] = false
					end
				else
					# if it is string null, we use nil, othewise, if it is not NA, we add it
					if value.downcase == "null"
						info_hash[header[ctr].strip()] = nil
					else
						info_hash[header[ctr].strip()] = value
					end
				end
			end
			ctr += 1
		end
		return info_hash
	end
	desc "incorporate new biomarkers/conditions from tsv template files"
	# bundle exec rake add_biomarkers_conditions:from_tsv["input_file.tsv","/apps/markerdb/log_for-this_run.tsv"] RAILS_ENV=
	task :from_tsv, [:info_file,:outfile] => [:environment] do |t, args|
		log = File.open(args[:outfile],'w')
		in_ptr = File.open(args[:info_file],'r')
		in_cont = in_ptr.readlines()
		header = in_cont.shift()
		header = header.split("\t")
		seen_biomarkers = obtain_existing_biomarkers()
		# each line is either a new biomarker/condition
		in_cont.each do |line|
			line_elem = line.split("\t")
			if header.length == line_elem.length
				marker_info = obtain_info_hash(line_elem,header)
			else
				raise RuntimeError.new("Entry marker: #{line_elem.join("\t")}. Doesn't match header length")
			end
			klass = marker_info["marker_class"].constantize
			# each transaction for each entry
			klass.transaction do
				# build/save each entry accordingly
				if klass.to_s == "Condition"
					condition = save_novel_conditions(marker_info)
					puts("added #{condition.name}")
					log.write("#{condition.id} #{condition.name} #{marker_info}\n")
				elsif klass.to_s == "Protein" or klass.to_s == "Chemical"
					marker_name = marker_info["name"]
					puts("#{marker_name}-#{klass}")
					if seen_biomarkers.keys.include?("#{marker_name}-#{klass}")
						marker = seen_biomarkers["#{marker_name}-#{klass}"]
					else
						# Creates the new biomarker if haven't seen it before
						max_mdbid = MarkerMdbid.all.order(mdbid: :desc).first.mdbid
						max_mdbid = max_mdbid.sub(/^MDB/,"").to_i
						# this is the largest possible id
						max_possible_id = 99999999
						# if next_id is 1 more than the current one
						next_id = max_mdbid + 1
						marker = klass.new(
							name: marker_info["name"],
							description: marker_info["description"],
							exported: true,
						)
						marker.save!
						if marker_info["marker_class"] == "Protein"
							marker = build_protein(marker_info,marker)
						else
							marker = build_chemical(marker_info,marker)
						end
						if next_id > max_possible_id
							raise RuntimeError.new("Update MDBIDS, max id exceeded by when adding #{marker_name}")
						else
							marker.create_marker_mdbid(mdbid: "MDB#{next_id.to_s.rjust(8,"0")}")
						end
						seen_biomarkers["#{marker_name}-#{klass}"] = marker
					end
					marker = save_protein_chemicals_info(marker,marker_info)
					log.write("marker #{marker.id} #{marker.name} #{marker_info}\n")
					# Rake::Task["update_markerdb:add_mdbid"].invoke()
				end
			end
		end
	end	
	desc "update concentrations and associated rocs where applicable"
	task :update_concentration_from_tsv, [:tsv, :log] => [:environment] do |t, args|
		log = File.open(args[:log],'w')
		in_ptr = File.open(args[:tsv],'r')
		in_cont = in_ptr.readlines()
		header = in_cont.shift()
		header = header.split("\t")
		seen_biomarkers = obtain_existing_biomarkers()
		# each line is a new update conc and/or associated rocs
		in_cont.each do |line|
			line_elem = line.split("\t")
			if header.length == line_elem.length
				marker_info = obtain_info_hash(line_elem,header)
			else
				raise RuntimeError.new("Entry marker: #{line_elem.join("\t")}. Doesn't match header length")
			end
			klass = marker_info["marker_class"].constantize
			# each transaction for each entry
			klass.transaction do
				# each line must be the concentration either protein or chemicals we're updating
				puts("udpating: #{marker_info["concentration_id"]}")
				conc_obj = Concentration.where("id = ?",marker_info["concentration_id"]).first
				if conc_obj.nil?
					puts("id #{marker_info["concentration_id"]} does not exists")
					STDIN.gets()
				else
					# update info for disease concentration
					conc_obj.condition_id = marker_info["condition_id"]
					conc_obj.mean = marker_info["disease_concentration_mean"]
					conc_obj.age_range = marker_info["disease_age_group"]
					conc_obj.sex = marker_info["disease_gender_group"]
					conc_obj.status = marker_info["status"]
					conc_obj.units = marker_info["concentration_units"]
					conc_obj.biofluid = marker_info["biofluid"]
					conc_obj.pvalue = marker_info["p_value"]
					# save references
					ref_obj = create_fetch_ref_obj(marker_info["disease_reference"].strip())
					# each citation_owner_type, citation_owner_id and reference id must be unique, so we are checking here
						# if different, we delete it and will make new one, else we leave it
						replace_citation = false
						conc_obj.citations.each do |each_citation|
							if each_citation.reference_id != conc_obj.id
								each_citation.delete
								replace_citation = true
							end
						end
						if replace_citation
							citation_obj = conc_obj.citations.build(
								reference_id: ref_obj.id)
							citation_obj.save!
						end
					# if no no max or min, then there is no range
					if marker_info.keys.include?("disease_concentration_max") and marker_info.keys.include?("disease_concentration_min")
						conc_obj.range = "#{marker_info["disease_concentration_min"]}-#{marker_info["disease_concentration_max"]}"
						conc_obj.level = "#{marker_info["disease_concentration_mean"]} (#{marker_info["disease_concentration_min"]}-#{marker_info["disease_concentration_max"]}) #{marker_info["concentration_units"]}"
					else
						conc_obj.level = "#{marker_info["disease_concentration_mean"]} #{marker_info["concentration_units"]}"
					end
					conc_obj.save!
					# obtain the reference concentration
					unless conc_obj.reference_conc_id.nil?
						ref_conc = Concentration.where("id = ?",conc_obj.reference_conc_id).first
						ref_conc.mean = marker_info["normal_concentration_mean"]
						ref_conc.age_range = marker_info["normal_age_group"]
						ref_conc.sex = marker_info["normal_gender_group"]
						ref_conc.units = marker_info["concentration_units"]
						ref_conc.biofluid = marker_info["biofluid"]
						# fetch or create reference object based
						ref_obj = create_fetch_ref_obj(marker_info["normal_reference"].strip())
						# each citation_owner_type, citation_owner_id and reference id must be unique, so we are checking here
						# if different, we delete it and will make new one, else we leave it
						replace_citation = false
						ref_obj.citations.each do |each_citation|
							if each_citation.reference_id != ref_obj.id
								each_citation.delete
								replace_citation = true
							end
						end
						if replace_citation
							citation_obj = ref_conc.citations.build(
								reference_id: ref_obj.id)
							citation_obj.save!
						end
						# if no no max or min, then there is no range
						if marker_info.keys.include?("normal_concentration_max") and marker_info.keys.include?("normal_concentration_min")
							ref_conc.range = "#{marker_info["normal_concentration_min"]}-#{marker_info["normal_concentration_max"]}"
							ref_conc.level = "#{marker_info["normal_concentration_mean"]} (#{marker_info["normal_concentration_min"]}-#{marker_info["normal_concentration_max"]}) #{marker_info["concentration_units"]}"
						else
							ref_conc.level = "#{marker_info["normal_concentration_mean"]} #{marker_info["concentration_units"]}"
						end
						ref_conc.save!
					end
					# update roc curves
					if conc_obj.quality_type = "RocStats"
						roc_original_dir = marker_info["roc_curve_directory"]
						roc_obj = RocStats.where("id = ?",conc_obj.quality_id).first
						unless roc_obj.nil?
							roc_obj.roc_auc = marker_info["roc_mean_AUC"]
							roc_obj.sensitivity = marker_info["roc_mean_sensitivity"]
							roc_obj.specificity = marker_info["roc_mean_specificity"]
							roc_obj.image_file_name = marker_info["roc_curve_filename"]
							roc_obj.image_file_size = File.size(File.join(roc_original_dir,marker_info["roc_curve_filename"]))
							roc_obj.save!
							if marker_info.keys.include?("simplified_threshold")
								roc_obj.roc_conc_threshold = marker_info["simplified_threshold"]
								roc_obj.save!
							end
							absolute_path = File.join(roc_original_dir,marker_info["roc_curve_filename"])
							# this saves it automatically to /system/roc_stats/images/000/.../
							roc_obj.image = open(absolute_path)
							roc_obj.save!
						end
					end
				end
				log.write("#{marker_info}\n")
			end
		end
		log.close()
	end
end