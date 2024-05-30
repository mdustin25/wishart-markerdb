namespace :concentration do 
  desc "Add concentrations entries from tsv file for existing biomarkers"
  task :add_exposure_conc, [:tsv,:out_file] => [:environment] do |t, args|
    log = File.open(args[:out_file],'w')
    ptr = File.open(args[:tsv],'r')
    cont = ptr.readlines()
    ptr.close()
    header = cont.shift()
    header = header.split("\t")
    cont.each do |line|
      line = line.strip()
      line_elem = line.split("\t")      
      info_hash = Hash.new
      ctr = 0
      # puts "header length " + header.length.to_s
      # puts "line elem length " + line_elem.length.to_s
      unless header.length != line_elem.length
        while(ctr < header.length)
          unless line_elem[ctr] == "NA"
            info_hash[header[ctr].strip()] = line_elem[ctr].strip()
          end
          ctr += 1
        end
      end
      puts info_hash["age_range"]
      klass = info_hash["solute_type"].constantize
      if klass.to_s == "Chemical"
        puts info_hash["solute_id"]
        marker = Chemical.find_by(name: info_hash["solute_id"])
        puts marker.name
      else
        marker_name = klass.find(info_hash["solute_id"])
        puts "marker name is " + marker_name.to_s
      end
      condition = Condition.find_by(name: info_hash["condition_id"])
      puts "condition is " + condition.name
      concentration = Concentration.where(solute_id: marker.id, condition_id: condition.id, level: info_hash["level"])
      puts concentration
      puts concentration[0]
      if concentration.nil? || concentration.empty?
        puts "creating new concentration entry"
      else
        puts "duplicate concentration"
        next
      end
      klass.transaction do
        conc = marker.concentrations.build(
          age_range: info_hash["age_range"],
          units: info_hash["units"],
          sex: info_hash["sex"],
          biofluid: info_hash["biofluid"],
          condition_id: condition.id,
          indication_type_id: 1,
          biomarker_category_id: 4,
          exported: true)
        conc.save!
        if info_hash.keys.include?("max") and info_hash.keys.include?("min")
          level = "#{info_hash["level"]} (#{info_hash["min"]}-#{info_hash["max"]}) #{info_hash["units"]}"
          conc.level = level
          conc.low = info_hash["min"]
          conc.high = info_hash["max"]
          conc.save!
        else
          level = "#{info_hash["level"]} #{info_hash["units"]}"
          conc.level = level
          conc.save!
        end
        if info_hash.keys.include?("special_constraints")
          conc.special_constraints = info_hash["special_constraints"]
          conc.save!
        end
        # disease_conc = Concentration.find(info_hash["disease_conc_id"])
        # disease_conc.reference_conc_id = norm_conc.id
        # disease_conc.save!
        #ref_obj = create_fetch_ref_obj(info_hash["reference"])
        citation_obj = conc.citations.build(
          reference_id: 367558)
        citation_obj.save!
        conc.save!
        log.write("norm: #{conc.id} #{line}\n")
      end
    end
  end

	desc "export referenced concentration where level is not empty"
  task :export_ref_conc => [:environment] do |t|
    all_concentrations = Concentration.all
    Concentration.transaction do
      all_concentrations.each do |each_concentration|
        citations = Citation.where("citation_owner_type = \"Concentration\" and citation_owner_id =?",each_concentration.id)
        if !citations.empty? and !each_concentration.level.empty?
          each_concentration.exported = true
          each_concentration.save!
        else
          each_concentration.exported = false
          each_concentration.save!
        end
      end
    end
  end

  
	desc "import hmdb concentration data in tsv format with pubmed reference"
  task :import_hmdb_conc, [:id_map,:in_file,:out_file] => [:environment] do |t,args|

    def grab_id_map(id_map_file)
      puts ("getting hmdb markerdb map")
      id_map = Hash.new
      File.open(id_map_file,'r').each_line do |line|
        line = line.split("\t")
        marker = Chemical.where("name = ?",line[0]).first
        id_map[line[1].strip()] = marker.id
      end
      return id_map
    end
    # REMEBER TO CHANGE THE LINE INDICES
    def grab_concentartion_info(line_elem)
      conc_info_hash = Hash.new
      conc_info_hash[:hmdb_id] = line_elem[1].strip()
      conc_info_hash[:condition] = line_elem[8].capitalize.strip()
      conc_info_hash[:age_range] = line_elem[7]
      conc_info_hash[:level] = line_elem[4]
      conc_info_hash[:sex] = line_elem[6]
      conc_info_hash[:biofluid] = line_elem[3]
      conc_info_hash[:units] = line_elem[5]
      return conc_info_hash
    end

    log = File.open(args[:out_file],'w')
    log.write("concentration_id\tcitation_id\tref_obj\n")
    id_map_file = args[:id_map]
    id_map = grab_id_map(id_map_file)
    
    conc_ctr = 0
    ref_ctr = 0
    file_ptr = File.open(args[:in_file],'r')
    file_cont = file_ptr.readlines()
    headers = file_cont.shift()
    puts(headers)
    file_ptr.close()
    Concentration.transaction do 
      file_cont.each do |line|
        puts("working on #{line}")
        line = line.strip()
        line_elem = line.split("\t")
        conc_info_hash = grab_concentartion_info(line_elem)
        # only import normal conditions for now
        if conc_info_hash[:condition].downcase == "normal"
          # grab reference_information
          # ref_type is the last element
          ref_type = line_elem[-1]
          if ref_type == "pubmed_id"
            pubmed_id = line_elem[10].strip()
            ref_obj = Reference.where("pubmed_id = ?",pubmed_id).order(:id).first
            if ref_obj.nil?
              ref_obj = Reference.new(
                pubmed_id: pubmed_id)
              ref_obj.save!
              ref_ctr += 1
            end
          elsif ref_type == "text"
            citation = line_elem[10].strip()
            ref_obj = Reference.where("citation = ?",citation).order(:id).first
            if ref_obj.nil?
              ref_obj = Reference.new(
                citation: citation)
              ref_obj.save!
              ref_ctr += 1
            end
          elsif ref_type == "link"
            link_url = line_elem[10].strip()
            link_name = line_elem[11].strip()
            ref_obj = Reference.where("citation = ? and url = ?",link_name,link_url).order(:id).first
            if ref_obj.nil?
              ref_obj = Reference.new(
                url: link_url,
                citation: link_name)
              ref_obj.save!
              ref_ctr += 1
            end
          end
          chem = Chemical.where("id = ?",id_map[conc_info_hash[:hmdb_id]]).first
          level = "#{conc_info_hash[:level]} #{conc_info_hash[:units]}"
          chem_conc = chem.concentrations.build(
            age_range: conc_info_hash[:age_range],
            level: level,
            sex: conc_info_hash[:sex],
            biofluid: conc_info_hash[:biofluid],
            units: conc_info_hash[:units],
            condition_id: 1,
            indication_type_id: 1,
            biomarker_category_id: 2,
            exported: true
            )
          chem_conc.save!
          conc_ctr += 1
          chem_conc_citation = chem_conc.citations.build(
            reference_id: ref_obj.id
            )
          chem_conc_citation.save!
          log.write("#{chem_conc.id}\t#{chem_conc_citation.id}\t#{ref_obj.id}\n")
        end
      end
      log.write("added #{conc_ctr} concentraionts\nadded #{ref_ctr} references\n")
    end
  end
end
