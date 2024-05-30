namespace :import do

  desc "import uniprot data"
  task :uniprot => [:environment] do
    require 'uniprot'

    Protein.transaction do
      pdb_link_type = LinkType.where(name:'pdb').first

      Protein.where('uniprot_id is not null').each do |p|
        raise "no uniprot" if p.uniprot_id.blank?
        data = Uniprot.annotate(p.uniprot_id)
        
        next if data.nil?
        if data[:description]
          p.description = data[:description] + " [Uniprot]"
        end

        if data[:general_function]
          p.general_function = data[:general_function] + " [Uniprot]"
        end
        p.uniprot_name = data[:uniprot_name]
        p.genecard_id = data[:genecard_id]
        p.hgnc_id = data[:hgnc_id]
        p.gene_name = data[:gene_name]
        p.protein_sequence = data[:polypeptide_sequence]

        # add pdb links
        data[:pdb_ids].each do |pdb_id|
          p.external_links.create( key: pdb_id, link_type: pdb_link_type)
        end

        #p.aliases.create(name: data[:name])
        #p.aliases.create(name: data[:gene_name])
        data[:synonyms].each do |name|
          p.aliases.new(name: name) unless p.aliases.where(name: name).any?
        end

        puts p.uniprot_id
        puts p.errors.messages unless p.save
      end
    end
  end

  task pdb_image: [:environment] do
    Protein.where.not(uniprot_id:nil).each do |p|
      p.fetch_structure_image_from_pdb
    end
  end


  task update_uniprot_ID: [:environment] do
    require 'csv'
    filepath = Rails.root.join("uniprotID.csv")

    CSV.foreach(filepath, :headers => true, encoding: "UTF-8") do |row|
      proteinName = row["name"]
      entry = Protein.find_by(name: proteinName)
      if entry.nil?
        next
      end
      unless row["uniprot_id"].nil?
        entry.uniprot_id = row["uniprot_id"]
      end
      entry.save
    end
  end


  
  desc 'import consumption exposure data from Exposome Explorer CSV'
  task :import_consumption => [:environment] do
    require 'csv'
    filepath = Rails.root.join("correlationsCurrated.csv")

    CSV.foreach(filepath, :headers => true, encoding: "UTF-8") do |row|
      
      if row["Biomarker"].blank?
        next
      end
      name = row["Intake"] + " Consumption"
      if Condition.where(name: name).pluck(:id).empty?
        condition = Condition.new  
        condition.name = name
        condition.save()
        puts "here"
      end
      biomarker = row["Biomarker"]
      condition_ID = Condition.where(name: name).pluck(:id)[0]
      biomarker_id = Chemical.where(name: biomarker).pluck(:id)[0]
      if Concentration.select(:id).where(solute_id: biomarker_id).where(condition_id: condition_ID).empty?
        entry = Concentration.new
        entry.condition_id = condition_ID
                
        entry.biofluid = row["Biospecimen"]
        biomarker = row["Biomarker"]
        entry.solute_id = Chemical.where(name: biomarker).pluck(:id)[0]
        if entry.solute_id.nil?
          next
        end
        
        
        biomarker_unit = row["Biomarker Unit"]
        if row["Biomarker Median"].nil?
          if row["Biomarker Geometric mean"].nil?
            biomarker_level = row["Biomarker Arithmetic mean"]
          elsif row["Biomarker Arithmetic mean"].nil?
            biomarker_level = row["Biomarker Geometric mean"]
          else 
            biomarker_level = nil
          end
        else
          biomarker_level = row["Biomarker Median"]
        end
        
        if biomarker_level.nil?
          next
        elsif biomarker_unit.nil?
          next
        else
          entry.level = biomarker_level + " " + biomarker_unit
        end 
        puts entry.level
      
        
        if row["Correlation p-value"]=="0.0" || row["Correlatation p-value"].blank?
          entry.pvalue = nil
        else
          entry.pvalue = row["Correlation p-value"]
        end
        population = row["Population"]
        if population.include?("Child") || population.include?("Children") || population.include?("Kid")
          entry.age_range = "Children:1-13 yrs old"
        elsif population.include?("Adult") || population.include?("University") || population.include?("Women") || population.include?("Men") 
          entry.age_range = "Adult:> 18"
        elsif population.include?("Elderly") || population.include?("elderly")
          entry.age_range = "Elderly:>65"
        elsif population.include?("Adolescent") || population.include?("Teen") || population.include?("High School") || population.include?("high school")
          entry.age_range = "Adolescent: 13-18"
        end
      
        if population.include?("Men") || population.include?("Male") || population.include?("Boy")
          entry.sex = "Male"
        elsif population.include?("Women") || population.include?("Female") || population.include?("Girl")
          entry.sex = "Female"
        else
          entry.sex = "Both"
        end
    
        entry.solute_type = "Chemical"
        entry.biomarker_category_id = "4"
        entry.indication_type_id = "1"
        entry.save()
      end
    end
  end

  desc 'import additional chemical biomarkers from exposome-explorer'
  task :exposure_biomarker_backup => [:environment] do
    require 'csv'
    require 'open-uri'
    require 'json'
    filepath = Rails.root.join("biomarkers.csv")
    CSV.open("biomarkers.csv", "r", :col_sep => ",").each do |row|
      name, id = row
      if Chemical.select(:id).where(name: name).empty?
        if id.nil?
          puts "empty hmdb id"
          next
        end
        puts id
        puts name
        begin
          puts "getting moldb"
          url = "http://moldb.wishartlab.com/molecules/" + id + ".json"
          moldb = JSON.load(open(url))
        rescue
          puts "rescuing"
          next
        end
        puts "checking for duplicates"
        puts "creating entry"
        entry = Chemical.new
        entry.name = name
        entry.description = nil
        entry.hmdb = id
        entry.moldb_smiles = moldb["smiles"]
        entry.moldb_formula = moldb["formula"]
        entry.moldb_inchi = moldb["inchi"]
        entry.moldb_inchikey = moldb["inchikey"]
        entry.moldb_iupac = moldb["iupac"]
        entry.moldb_logp = moldb["logp"]
        entry.moldb_pka = moldb["pka"]
        entry.moldb_average_mass = moldb["average_mass"]
        entry.moldb_mono_mass = moldb["mono mass"]
        entry.moldb_alogps_solubility = moldb["alogps_solubility"]
        entry.moldb_alogps_logp = moldb["alogps_logp"]
        entry.moldb_alogps_logs = moldb["alogps_logs"]
        entry.moldb_acceptor_count = moldb["acceptor_count"]
        entry.moldb_donor_count = moldb["donor_count"]
        entry.moldb_rotatable_bond_count = moldb["rotatable_bond_count"]
        entry.moldb_polar_surface_area = moldb["polar_surface_area"]
        entry.moldb_refractivity = moldb["refractivity"]
        entry.moldb_polarizability = moldb["polarizability"]
        entry.moldb_traditional_iupac = moldb["traditional_iupac"]
        entry.moldb_formal_charge = moldb["formal_charge"]
        entry.moldb_physiological_charge = moldb["physiological_charge"]
        entry.moldb_pka_strongest_basic = moldb["pka_strongest_basic"]
        entry.moldb_pka_strongest_acidic = moldb["pka_strongest_acidic"]
        entry.moldb_bioavailability = moldb["bioavailability"]
        entry.moldb_number_of_rings = moldb["number_of_rings"]
        entry.moldb_rule_of_five = moldb["rule_of_five"]
        entry.moldb_ghose_filter = moldb["ghose_filter"]
        entry.moldb_veber_rule = moldb["veber_rule"]
        entry.moldb_mddr_like_rule = moldb["mddr_like_rule"]
        entry.save(validate: false)

        bcm = BiomarkerCategoryMembership.where("biomarker_type = ? and biomarker_id = ? and condition_id = ? and biomarker_category_id = ?",each_conc.solute_type,each_conc.solute_id,each_conc.condition_id,each_conc.biomarker_category_id).first
      end
    end
    
  end


  desc 'import additional chemical biomarkers from exposome-explorer'
  task :exposure_biomarker => [:environment] do
    require 'csv'
    require 'open-uri'
    require 'json'
    filepath = Rails.root.join("biomarkers.csv")
    CSV.open("biomarkers.csv", "r", :col_sep => ",").each do |row|
      name, id = row
      if Chemical.select(:id).where(name: name).empty?
        if id.nil?
          puts "empty hmdb id"
          next
        end
        puts id
        puts name
        begin
          puts "getting moldb"
          url = "http://moldb.wishartlab.com/molecules/" + id + ".json"
          url_full = "http://moldb.wishartlab.com/molecules/" + id + "/curation.json"
          moldb = JSON.load(open(url))
          moldb_full = JSON.load(open(url_full))
        rescue
          puts "rescuing"
          next
        end
        puts "checking for duplicates"
        puts "creating entry"
        entry = Chemical.new
        entry.name = name
        if !moldb_full["descriptions"].empty? 
          if !moldb_full["descriptions"].find {|x| x["source"] == "HMDB" }.nil?
            entry.description = moldb_full["descriptions"].find {|x| x["source"] == "HMDB" }["name"]
          else 
            entry.description = moldb_full["descriptions"][0]["name"]
          end
        elsif !moldb_full["cs_descriptions"].empty?
          entry.description = moldb_full["cs_descriptions"]["1"]
        else
          entry.description = nil
        end
        entry.hmdb = id
        entry.moldb_smiles = moldb["smiles"]
        entry.moldb_formula = moldb["formula"]
        entry.moldb_inchi = moldb["inchi"]
        entry.moldb_inchikey = moldb["inchikey"]
        entry.moldb_iupac = moldb["iupac"]
        entry.moldb_logp = moldb["logp"]
        entry.moldb_pka = moldb["pka"]
        entry.moldb_average_mass = moldb["average_mass"]
        entry.moldb_mono_mass = moldb["mono mass"]
        entry.moldb_alogps_solubility = moldb["alogps_solubility"]
        entry.moldb_alogps_logp = moldb["alogps_logp"]
        entry.moldb_alogps_logs = moldb["alogps_logs"]
        entry.moldb_acceptor_count = moldb["acceptor_count"]
        entry.moldb_donor_count = moldb["donor_count"]
        entry.moldb_rotatable_bond_count = moldb["rotatable_bond_count"]
        entry.moldb_polar_surface_area = moldb["polar_surface_area"]
        entry.moldb_refractivity = moldb["refractivity"]
        entry.moldb_polarizability = moldb["polarizability"]
        entry.moldb_traditional_iupac = moldb["traditional_iupac"]
        entry.moldb_formal_charge = moldb["formal_charge"]
        entry.moldb_physiological_charge = moldb["physiological_charge"]
        entry.moldb_pka_strongest_basic = moldb["pka_strongest_basic"]
        entry.moldb_pka_strongest_acidic = moldb["pka_strongest_acidic"]
        entry.moldb_bioavailability = moldb["bioavailability"]
        entry.moldb_number_of_rings = moldb["number_of_rings"]
        entry.moldb_rule_of_five = moldb["rule_of_five"]
        entry.moldb_ghose_filter = moldb["ghose_filter"]
        entry.moldb_veber_rule = moldb["veber_rule"]
        entry.moldb_mddr_like_rule = moldb["mddr_like_rule"]
        entry.exported = 1
        entry.save(validate: false)

      end
    end
    
  end

  task :update_exposure_category => [:environment] do
    results = Condition.where(Condition.arel_table[:name].matches('%Consumption%'))
    results.each do |row|
      id = row.id
      ActiveRecord::Base.connection.execute("INSERT INTO condition_categories_conditions (condition_category_id, condition_id) VALUES (6, #{id});")
      
    end
  end

  task :polutant_import => [:environment] do
    require 'csv'
    filepath = Rails.root.join("Pollutants.csv") # an excel with name and ID of polutants correlating to Exposome Explorers Concentration data
    
    CSV.foreach(filepath, :headers => true, encoding: "UTF-8") do |row|
      name = "Exposure To " + row["Classification"]
      if Condition.where(name: name).pluck(:id).empty?
        condition = Condition.new  
        condition.name = name
        
        condition.save()
      end
      temp = row["Biomarker"]
      biomarker = Chemical.where(Chemical.arel_table[:name].matches("%#{}%")).first
      
      condition_ID = Condition.where(name: name).pluck(:id)[0]
      ActiveRecord::Base.connection.execute("INSERT INTO condition_categories_conditions VALUES (6, #{condition_ID});")
      entry = Concentration.new
      population = row['Population']
      
     

      
      
      
    end    
  end
  
end

