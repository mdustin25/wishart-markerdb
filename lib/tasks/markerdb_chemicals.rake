namespace :chemical do
  desc "add panel chemical biomarkers"
  task :import_panel_chem, [:infile,:log] => [:environment] do |t, args|
    log = File.open(args[:log],'w')
    log.write("marker_id\tpanel_marker_id\tpanel_conc_id\troc_id\n")
    info = File.open(args[:infile],'r')
    cont = info.readlines()
    header = cont.shift()
    info.close()
    panel_ctr = 1
    cont.each do |each_line|
      Chemical.transaction do
        each_line_cont = each_line.split("\t")
        involved_markers = each_line_cont[9].split(",").map { |e| e.strip()  }
        condition_id = each_line_cont[2]
        biofluid = each_line_cont[3]
        auc = each_line_cont[4]
        sens = each_line_cont[5]
        spec = each_line_cont[6]
        roc_name = each_line_cont[7]
        roc_dir = each_line_cont[8]
        log_exp = each_line_cont[11].tr(";", "")
        # each line is 1 panel_marker
        # name MUST START WITH the word "Panel"
        marker_names = "Panel_etnry: #{panel_ctr.to_s} membership in logeq"
        panel_marker = Chemical.new(
          name: marker_names,
          description: "Panel marker for #{marker_names}. It is used only so a corresponding concentration entries can be created and should NOT be accessible by public user",
          exported: false
        )
        
        panel_marker.save!
        panel_ctr += 1
        panel_conc_entry = panel_marker.concentrations.build(
          biofluid: biofluid,
          condition_id: condition_id,
          biomarker_category_id: 2,
          indication_type_id: 1,
          logistic_equation: log_exp,
          exported: false,
          special_constraints: nil,
          status: "Investigational"
        )
        panel_conc_entry.save!
        roc_stat = RocStats.new(
                    roc_auc: auc,
                    sensitivity: sens,
                    specificity: spec,
                    image_file_name: roc_name,
                    image_content_type: "image/png",
                    image_file_size: File.size(File.join(roc_dir,roc_name))
                    )
        roc_stat.save!
        absolute_path = File.join(roc_dir,roc_name)
        # this saves it automatically to /system/roc_stats/images/000/.../
        roc_stat.image = open(absolute_path)
        roc_stat.save!
        panel_conc_entry.quality_type = roc_stat.class
        panel_conc_entry.quality_id  = roc_stat.id
        panel_conc_entry.save!
        # link each marker to the right panel
        involved_markers.each do |each_marker|
          next if each_marker == "NONE"
          marker = Chemical.find(each_marker)
          marker.panel_single = "panel"
          if marker.panel_marker_id.nil?
            marker.panel_marker_id = panel_marker.id
          else  
            panel_marker_ids = marker.panel_marker_id.split(",")
            panel_marker_ids << panel_marker.id
            marker.panel_marker_id = panel_marker_ids.join(",")
          end
          marker.save!
          log.write("#{marker.id}\t#{panel_marker.id}\t#{panel_conc_entry.id}\t#{roc_stat.id}\n")
        end
      end
    end
    log.close()
  end

  desc "add synonyms to chemicals"
  task :add_synonyms => [:environment] do |t|
    require 'csv'
    filepath = Rails.root.join("synonyms.tsv")
    CSV.foreach(filepath, encoding: "UTF-8", :col_sep => "\t") do |row|
      name, synonym = row
      c = Chemical.find_by(name: name)
      puts "adding synonyms for " + name
      if !c.nil?
        c.aliases.new(name: synonym) 
        c.save!
      end
    end
  end
  
  desc "add ROC curve to existing concentrations"
  task :add_roc => [:environment] do |t|
    require 'csv'
    filepath = Rails.root.join("roc_info.tsv")
    CSV.foreach(filepath, :headers => true, encoding: "UTF-8", :col_sep => "\t") do |row|
      puts row
      name = row["name"]
      condition = row["hmdb_condition"]
      roc_dir = "data/roc/"
      roc_name = row["roc_curve_filename"]
      puts name
      puts condition
      chem = Chemical.find_by(name: name)
      cond = Condition.find_by(name: condition)
      puts "chemical is # " + chem.id.to_s
      puts "condition is # " + cond.id.to_s
      conc = Concentration.find_by(solute_id: chem.id, condition_id: cond.id)
      if conc.nil?
        next
      else

        roc_stat = RocStats.new(
          roc_auc: row["roc_mean_AUC"],

          sensitivity: row["roc_mean_sensitivity"],
          specificity: row["roc_mean_specificity"],
          roc_conc_threshold: row["simplified_threshold"],
          image_file_name: roc_name,
          image_content_type: "image/png",
          image_file_size: File.size(File.join(roc_dir,roc_name))
        )
        roc_stat.save!
        absolute_path = Rails.root.join(roc_dir,roc_name)
        puts absolute_path
          # this saves it automatically to /system/roc_stats/images/000/.../
        roc_stat.image = open(absolute_path)
        roc_stat.save!
        conc.quality_type = roc_stat.class
        conc.quality_id  = roc_stat.id
        conc.pvalue = row["p_value"]
        conc.save!
      end
    end
  end
        


  desc "set exported to true for all chemical"
  task :export_chem => [:environment] do |t|
    all_chem = Chemical.order(:id)
    Chemical.transaction do
      all_chem.each do |each_chem|
        linked_concentration = Concentration.where("solute_type = \"Chemical\" and exported = true and solute_id = ? ",each_chem.id)
        if linked_concentration.length > 0
          each_chem.exported = true
          each_chem.save!
        else
          each_chem.exported = false
          each_chem.save!
        end
      end
    end
  end
  desc "tmp task to just add units to the roc_curve based concentrations"
  task :update_roc_curve => [:environment] do |t|
    all_chem_conc = Concentration.where("solute_type = \"Chemical\" and exported=true and quality_type =\"RocStats\"")
    RocStats.transaction do 
      all_chem_conc.each do |chem_conc|
        roc_stat = RocStats.find(chem_conc.quality_id)
        new_roc_based_conc = roc_stat.roc_conc_threshold
        units = chem_conc.units
        roc_stat.roc_conc_threshold = "#{new_roc_based_conc} #{units}"
        roc_stat.save!
      end
    end
  end



  desc "set chemicals to single markers as all are such at the moment"
  task :set_chem_panel_stats => [:environment] do |t|
    all_chem = Chemical.exported
    all_chem.each do |chem|
      if chem.panel_single.nil?
        chem.panel_single = "single marker"
        chem.save!
      else
        next
      end
    end
  end
  desc "clean up descriptions of chemicals"
  task :cleanup_chem_desc, [:desc_file] => [:environment] do |t,args|
    file_name = args[:desc_file]
    cont_ptr = File.open(file_name,'r')
    Chemical.transaction do 
      cont_ptr.each_line do |line|
        line = line.split("\t")
        id = line[0]
        puts("working on #{id}")
        desc = line[2]
        chem = Chemical.where("id = ?",id).first
        chem.description = desc
        chem.save!  
      end
    end
  end
end