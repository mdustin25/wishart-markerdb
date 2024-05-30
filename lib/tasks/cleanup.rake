namespace :dedupe do
  #def select_same_concentrations
    #attributes_to_compare = %w[
      #level biofluid units age_range condition_id indication_type_id
    #]

    #attributes_to_compare.reduce(true) do |is_same,attribute|
      #is_same && (g1.send(attribute) == g2.send(attribute))
    #end

  #end

  desc "Deduplicate placeholder concentrations"
  task placeholder_concentrations: [:environment] do
    # Find concentrations with 'placeholder' indication type
    placeholder_id = IndicationType.where(indication:"placeholder").first.id
    puts "Placeholder ID: #{placeholder_id}"
    placeholder_concentrations =
      Concentration.where(indication_type_id: placeholder_id)

    puts "Found #{placeholder_concentrations.count} placeholder concentrations"

    placeholder_concentrations.each do |c|
      matching = Concentration
        .where(
          condition_id: c.condition_id,
          level:c.level,
          age_range: c.age_range)
        .where.not(indication_type_id: c.indication_type_id)

      if matching.any?
        puts "Found match for #{c.id} with level: #{c.level}"
        c.delete
      else
        puts "No match for #{c.id}"
      end
    end
  end

  desc "Deduplicate concentrations"
  task concentrations: [:environment] do
    conditions = Concentration.where.not(condition_id:1).group_by(&:condition_id)
    conditions.map do |condition,concentrations|
      # collect duplicated concentrations
      duped_concentrations =
        concentrations.
        group_by{|c| "#{c.condition_id}|#{c.age_range}|#{c.level}|#{c.biofluid}|#{c.citations.pluck(:reference_id).sort.join(':')}" }.
        select{|i,levels| levels.count > 1 }
        #puts duped_concentrations.map{|k,v| v.map(&:id).join "," }
        duped_concentrations.each_pair do |k,dupes|
          to_keep = dupes.shift
          dupes.map(&:delete)
          puts "Kept concentration: #{to_keep.id}"
        end
    end
  end


end


namespace :cleanup do

  desc "Add new condition category Urinary System Disorder"
  task urinary: [:environment] do
    cat=ConditionCategory.new()
    cat.name = "Urinary System Disorder"
    cat.save!

  end

  desc "Remove dangling citations"
  task dangling_citations: [:environment] do
    # Delete citations that link to a non-existant reference
    ActiveRecord::Base.connection.execute(<<-SQL)
    delete from citations where id in (
      SELECT cit_id AS id FROM (
        SELECT  citations.id as cit_id, citations.reference_id, `references`.id as other_id 
        FROM `citations`
        LEFT OUTER JOIN `references` ON citations.reference_id = `references`.id
      ) as temp1
      where other_id is null
    );
    SQL
  end

  desc "Remove personal communications references"
  task personal_communications: [:environment] do
    ActiveRecord::Base.connection.execute(<<-SQL)
    delete FROM `references` where citation like "%Personal Communication%";
    SQL
  end

  desc "Remove chemical aliases for replacement"
  task chem_alias: [:environment] do
    ActiveRecord::Base.connection.execute(<<-SQL)
    delete FROM `aliases` where aliasable_type like "%Chemical%";
    SQL
  end


  desc "Removing Duplicated Conditions Category"
  task duplicated_category: [:environment] do
    ActiveRecord::Base.connection.execute("UPDATE condition_categories_conditions SET condition_category_id='2' WHERE condition_category_id='34';")
    ActiveRecord::Base.connection.execute("UPDATE condition_categories_conditions SET condition_category_id='8' WHERE condition_category_id='22';")
    ActiveRecord::Base.connection.execute("UPDATE condition_categories_conditions SET condition_category_id='1' WHERE condition_category_id='16'")
    ActiveRecord::Base.connection.execute("UPDATE condition_categories_conditions SET condition_category_id='25' WHERE condition_category_id='12'")
    ActiveRecord::Base.connection.execute("UPDATE condition_categories_conditions SET condition_category_id='17' WHERE condition_category_id='4'")
    ActiveRecord::Base.connection.execute("DELETE FROM condition_categories WHERE id='34' OR id='22' OR id='16' OR id='12' OR id='4' OR id='3' OR id='36' OR id='9' OR id='33' OR id='32' OR id='18';")
  end

  desc "Removing Streptococcus Infection"
  task remove_karyotype_condition: [:environment] do
    ActiveRecord::Base.connection.execute("DELETE FROM karyotype_indications WHERE condition_id='6231';")
    ActiveRecord::Base.connection.execute("DELETE FROM karyotype_indications WHERE condition_id='6256';")
    ActiveRecord::Base.connection.execute("DELETE FROM karyotype_indications WHERE condition_id='6252';")
    ActiveRecord::Base.connection.execute("DELETE FROM karyotype_indications WHERE condition_id='6253';")
    
    
  end

  task :add_bmcat, [:csv_file] => [:environment] do |t, args|
    in_file = args[:csv_file]
    CSV.foreach(in_file, :headers => true, :col_sep => "\t") do |row|
      bcm = BiomarkerCategoryMembership.new(
        biomarker_id: row["biomarker_id"],
        biomarker_name: row["biomarker_name"],
        biomarker_type: row["biomarker_type"],
        mdbid: row["mdbid"],
        condition_id: row["condition_id"],
        condition_name: row["condition_name"],
        biomarker_category_id: row["biomarker_category_id"]
        )
      bcm.save!
    end
  end

  task :add_alias, [:csv_file] => [:environment] do |t, args|
    in_file = args[:csv_file]
    CSV.foreach(in_file, :headers => true, :col_sep => "\t") do |row|
      a = Alias.new(
        aliasable_id: row["id"],
        name: row["name"],
        aliasable_type: "Chemical"
        )
      a.save!
      puts a.aliasable_id
    end
  end  

  task :add_seq, [:csv_file] => [:environment] do |t, args|
    in_file = args[:csv_file]
    CSV.foreach(in_file, :headers => true, :col_sep => "\t") do |row|
      seq = Sequence.new(
        type: "GeneSequence",
        sequenceable_id: row["sequenceable_id"],
        sequenceable_type: "Gene",
        header: row["header"],
        chain: row["chain"]
        )
      seq.save!
    end
  end  

  desc "remove unexported conditions from the database"
  task :condition_remove, [:csv_file] => [:environment] do |t,args|
    in_file = args[:csv_file]
    CSV.foreach(in_file, :headers => true, :col_sep => "\t") do |row|
      id = row["id"]
      ActiveRecord::Base.connection.execute("DELETE FROM conditions WHERE id = #{id};")
    end
  end


  desc "remove condition/category associations"
  task :ccc_remove, [:csv_file] => [:environment] do |t,args|
    in_file = args[:csv_file]
    CSV.foreach(in_file, :headers => true, :col_sep => "\t") do |row|
      c_c_id = row["condition_category_id"]
      c_id = row["condition_id"]
      ActiveRecord::Base.connection.execute("DELETE FROM condition_categories_conditions WHERE condition_category_id = #{c_c_id} and condition_id = #{c_id};")
    end
  end

  desc "add condition/category associations"
  task :ccc_add, [:csv_file] => [:environment] do |t,args|
    in_file = args[:csv_file]
    CSV.foreach(in_file, :headers => true, :col_sep => "\t") do |row|
      c_c_id = row["condition_category_id"]
      c_id = row["condition_id"]
      ActiveRecord::Base.connection.execute("INSERT INTO condition_categories_conditions (condition_category_id, condition_id) VALUES (#{c_c_id}, #{c_id});")
    end
  end 

  desc "clean up roc curves"
  task :remove_roc_curves, [:log] => [:environment] do |t, args|
    log = File.open(args[:log],'w')
    roc_conc = Concentration.where("exported = true and quality_type = 'RocStats'")
    roc_conc.each do |each_conc|
      # puts(each_conc.solute_id)
      roc = RocStats.where("id = ?",each_conc.quality_id).first
      # if the roc object doesn't exist or if the image doesn't exist
      if roc.nil? or !roc.image.exists?
        # if the roc object itself doesn't exist, then the concentration is referencing nothing
        # reset it
        if roc.nil?
          each_conc.quality_type = nil
          each_conc.quality_id = nil
        # if the roc object exists, but there is no image, we destroy the roc object and reset it
        else
          if !roc.image.exists?
            roc.destroy!
            each_conc.quality_type = nil
            each_conc.quality_id = nil
          end
        end
        log.write("#{each_conc.id} #{each_conc.solute_type} #{each_conc.solute_id}\n")
        each_conc.save!
      end
    end
    log.close()
  end


  desc "delete from tsv"
  task :delete_from_tsv, [:tsv] => [:environment] do |t, args|
    cont = File.open(args[:tsv],'r')
    cont.each do |each_line|
      each_line_elem = each_line.strip().split("\t")
      klass = each_line_elem[0].constantize
      id = each_line_elem[1]
      elem = klass.find(id)
      elem.destroy!
    end
  end
  desc "add bmcat ids"
  task :add_bmcat_ids, [:tsv] => [:environment] do |t, args|
    ptr = File.open(args[:tsv],'r')
    cont = ptr.readlines()
    added = Array.new
    cont.each do |each_conc_id|
      each_conc = Concentration.find(each_conc_id)
      cond = Condition.find(each_conc.condition_id)
      biomarker = each_conc.solute_type.constantize.find(each_conc.solute_id)
      unless cond.id == 1
        unless added.include?("#{each_conc.solute_id}-#{each_conc.solute_type}-#{each_conc.condition_id}")
          bm_member = BiomarkerCategoryMembership.new(
            biomarker_id: each_conc.solute_id,
            biomarker_type: each_conc.solute_type,
            biomarker_category_id: each_conc.biomarker_category_id,
            condition_id: each_conc.condition_id,
            condition_name: cond.name,
            mdbid: biomarker.marker_mdbid.mdbid,
            biomarker_name: biomarker.name)
          bm_member.save!
          added << "#{each_conc.solute_id}-#{each_conc.solute_type}-#{each_conc.condition_id}"
        end
      end
    end
  end

  desc "add source stmt to biomarkers"
  task :add_stmt_biomarkers, [:log] => [:environment] do |t,args|
    log = File.open(args[:log],'w')
    log.write("biomarker_type\tbiomarker_id\n")
    all_chem = Chemical.where("exported = true")
    chem_stmt = "This text was researched, composed and written by the MarkerDB curation team. Source information was obtained from the Human Metabolome Database (<a href=\"https://www.hmdb.ca\">HMDB</a>) <a href=\"https://www.wikipedia.org\">Wikipedia</a>, and the <a href=\"https://www.cdc.gov/biomonitoring\">CDC</a>. Last update: April 2023."
    prot_stmt = "This text was researched, composed and written by the MarkerDB curation team. Source information was obtained from the Protein Databank (<a href=\"https://www.rcsb.org\">PDB</a>), <a href=\"https://www.uniprot.org\">UniProt</a> and <a href=\"https://www.wikipedia.org\">Wikipedia</a>. Last update: Aug. 2020."
    gene_stmt = "This text was researched, composed and written by the MarkerDB curation team. Source information was obtained from the <a href=\"https://medlineplus.gov/genetics/\">NIH Genetics Home Reference</a>, <a href=\"https://www.uniprot.org\">UniProt</a> and <a href=\"https://www.wikipedia.org\">Wikipedia</a>. Last update: Aug. 2020."
    karyo_stmt = "This text was researched, composed and written by the MarkerDB curation team. Source information was obtained from the <a href=\"http://www.atlasgeneticsoncology.org\">Atlas of Genetics and Cytogenetics in Oncology and Haematology</a>. Last update: Aug. 2020."
    cond_stmt = "This text was researched, composed and written by the MarkerDB curation team. Source information was obtained from the <a href=\"https://medlineplus.gov/genetics/\">NIH Genetics Home Reference</a>, the <a href=\"https://www.rarediseases.org\">National Organization for Rare Diseases</a>, the <a href=\"https://www.mayoclinic.org/diseases-conditions\">Mayo clinic</a>, <a href=\"https://www.wikipedia.org\">Wikipedia</a> and the <a href=\"https://www.cdc.gov/biomonitoring\">CDC</a>. Last update: April 2023."
    Chemical.transaction do
      all_chem.each do |each_chem|
        each_chem.info_source  = chem_stmt
        each_chem.save!
        log.write("#{each_chem.class}\t#{each_chem.id}\n")
      end
    end
    Protein.transaction do
      all_prot = Protein.where("exported = true")
      all_prot.each do |each_prot|
        each_prot.info_source = prot_stmt
        each_prot.save!
        log.write("#{each_prot.class}\t#{each_prot.id}\n")
      end
    end
    Karyotype.transaction do
      all_karyo = Karyotype.where("exported = true")
      all_karyo.each do |each_karyo|
        each_karyo.info_source = karyo_stmt
        each_karyo.save!
        log.write("#{each_karyo.class}\t#{each_karyo.id}\n")
      end
    end
    Gene.transaction do
      all_genes = Gene.where("id in (?)",SequenceVariant.where("exported = true").pluck(:gene_id))
      all_genes.each do |each_gene|
        each_gene.info_source = gene_stmt
        each_gene.save!
        log.write("#{each_gene.class}\t#{each_gene.id}\n")
      end
    end
    Condition.transaction do
      all_conds = Condition.where("exported = true")
      all_conds.each do |each_cond|
        each_cond.info_source = cond_stmt
        each_cond.save!
        log.write("#{each_cond.class}\t#{each_cond.id}\n")
      end
    end
    log.close()
  end
end


