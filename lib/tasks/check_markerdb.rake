namespace :check_markerdb do
  def check_seqvarmeas_bmcat(all_svm)
    all_svm.each do |each_svm|
      unless each_svm.condition_id == 1
        bcm = BiomarkerCategoryMembership.where("biomarker_type = \"SequenceVariant\" and biomarker_id = ? and condition_id = ? and biomarker_category_id = ?",each_svm.sequence_variant_id,each_svm.condition_id,each_svm.biomarker_category_id).first
        if bcm.nil?
          seq_var = SequenceVariant.find(each_svm.sequence_variant_id)
          cond = Condition.find(each_svm.condition_id)
          if seq_var.exported == 1
            # puts("working on #{seq_var.variation}")
            bcm = BiomarkerCategoryMembership.new(
              biomarker_id: seq_var.id,
              biomarker_name: seq_var.variation,
              biomarker_type: seq_var.class,
              mdbid: seq_var.marker_mdbid.mdbid,
              condition_id: cond.id,
              condition_name: cond.name,
              biomarker_category_id: each_svm.biomarker_category_id
              )
            bcm.save!
          end
        end
      end
    end
  end
  def check_conc_bmcat(all_conc)
    all_conc.each do |each_conc|
      unless each_conc.condition_id == 1
        bcm = BiomarkerCategoryMembership.where("biomarker_type = ? and biomarker_id = ? and condition_id = ? and biomarker_category_id = ?",each_conc.solute_type,each_conc.solute_id,each_conc.condition_id,each_conc.biomarker_category_id).first
        if bcm.nil?
          marker = each_conc.solute_type.constantize.find(each_conc.solute_id)
          cond = Condition.find(each_conc.condition_id)
          if marker.exported == true
            # puts("working on #{marker.name} #{marker.class}")
            bcm = BiomarkerCategoryMembership.new(
              biomarker_id: marker.id,
              biomarker_name: marker.name,
              biomarker_type: marker.class,
              mdbid: marker.marker_mdbid.mdbid,
              condition_id: cond.id,
              condition_name: cond.name,
              biomarker_category_id: each_conc.biomarker_category_id
              )
            bcm.save!
          end
        end
      end
    end
  end
  def check_karyo_bmcat(all_karyo)
    all_karyo.each do |each_karyo|
      unless each_karyo.condition_id == 1
      bcm = BiomarkerCategoryMembership.where("biomarker_type = ? and biomarker_id = ? and condition_id = ? and biomarker_category_id = ?","Karyotype",each_karyo.karyotype_id,each_karyo.condition_id,each_karyo.biomarker_category_id).first
        if bcm.nil?
          marker = Karyotype.find(each_karyo.karyotype_id)
          cond = Condition.find(each_karyo.condition_id)
          # puts("working on #{marker.karyotype} #{marker.class}")
          bcm = BiomarkerCategoryMembership.new(
            biomarker_id: marker.id,
            biomarker_name: marker.karyotype,
            biomarker_type: marker.class,
            mdbid: marker.marker_mdbid.mdbid,
            condition_id: cond.id,
            condition_name: cond.name,
            biomarker_category_id: each_karyo.biomarker_category_id
            )
          bcm.save!
        end
      end
    end
  end
  def clean_bmcat_membership
    bmcat_mems = BiomarkerCategoryMembership.all()
    to_delete = Array.new
    bmcat_mems.each do |each_bm|
      marker = each_bm.biomarker_type.constantize.where("exported = true and id = ?",each_bm.biomarker_id).first
      unless marker.nil?
        # if it exist, if the category is obsolete (i.e., this measurement is no longer a particular category)
        if marker.class == "Chemical" or marker.class == "Protein"
          bmcat_ref = Concentration.where("solute_type = ? and solute_id = ? and biomarker_category_id = ?",marker.class,marker.id,each_bm.biomarker_id)
          # regardless of exproted status, there isn't any, so no concentration for a particular marker, biomarker_category combination
          # will remove
          if bmcat_ref.length<1
            unless to_delete.include?(each_bm.id)
              to_delete << each_bm.id
            end
          else
            # if there are concentrations
            # each_bmcat_ref is the one we want, the one in the concentration table
            bmcat_ref.each do |each_bmcat_ref|
              # if this is not the same as the condition_id in the biomarkercategory that one is old and we can remove it
              if each_bmcat_ref.condition_id != each_bm.condition_id
                to_delete << each_bm.id
              else
                # even if the condition_id matches, if the concentration has been unexported, we don't want to show it
                # remove it from biomarker category membership
                if each_bmcat_ref.exported.to_s = "false"
                  to_delete << each_bm.id
                end
              end
            end
          end
        elsif marker.class == "Karyotype"
          bmcat_ref = KaryotypeIndication.where("solute_id = ? and biomarker_category_id = ?",marker.id, each_bm.biomarker_id)
          if bmcat_ref.length<1
            unless to_delete.include?(each_bm.id)
              to_delete << each_bm.id
            end
          else
            bmcat_ref.each do |each_bmcat_ref|
              # each_bmcat_ref is the one we want, the one in the concentration table
              # if this is not the same as the condition_id in the biomarkercategory that one is old and we can remove it
              if each_bmcat_ref.condition_id != each_bm.condition_id
                to_delete << each_bm.id
              end
            end
          end
        elsif marker.class == "SequenceVariant"
          bmcat_ref = SequenceVariantMeasurement.where("solute_id = ? and biomarker_category_id = ?",marker.id, each_bm.biomarker_id)
          if bmcat_ref.length<1
            unless to_delete.include?(each_bm.id)
              to_delete << each_bm.id
            end
          else
            bmcat_ref.each do |each_bmcat_ref|
              # each_bmcat_ref is the one we want, the one in the concentration table
              # if this is not the same as the condition_id in the biomarkercategory that one is old and we can remove it
              if each_bmcat_ref.condition_id != each_bm.condition_id
                to_delete << each_bm.id
              end
            end
          end
        end
        # if the mdbid or biomarker name also changed, we remove it as well
        unless each_bm.biomarker_type == "SequenceVariant"
          if each_bm.mdbid != marker.marker_mdbid.mdbid
            to_delete << each_bm.id
          elsif each_bm.biomarker_name != marker.name
            to_delete<< each_bm.id
          end
        else
          if each_bm.mdbid != marker.marker_mdbid.mdbid
            to_delete << each_bm.id
          elsif each_bm.biomarker_name != marker.variation
            to_delete<< each_bm.id
          end
        end
      else
        # the marker is obsolete
        unless to_delete.include?(each_bm.id)
          to_delete << each_bm.id
        end
      end
    end
    unless to_delete.blank?
      to_delete.each do |each_elem|
        elem = BiomarkerCategoryMembership.find(each_elem)
        elem.delete
      end
    end
  end
  desc "check biomarker categories for all biomarkers and ensure relevant tables are consistent"
  task :biomarker_categories => [:environment] do |t|
    # ensure biomarker_category_memberships correctly reflect biomarkers, biomarker_categories and conditions
    # will update biomarker_category_memberships as needed
    # Essentially instead of doing a bunch of joins in the controller, we do it here
    # takes a long time to add data, but once added, easy to access
    BiomarkerCategoryMembership.transaction do
      # remove obsolete reference in biomarker_category_memberships

      # Eponine/Xuan: Uncomment this method after adding to seq_var_meas the "predictive" biomarkers
      # otherwise this would delete those ones.
      # puts("Removing obsolete marker references and biomarker category references")
      # clean_bmcat_membership()

    end
    BiomarkerCategoryMembership.transaction do
      # check all sequence variants
      puts("filling in sequence variant measurement biomarker category references")
      all_svm = SequenceVariantMeasurement.order(:id)
      check_seqvarmeas_bmcat(all_svm)
    end
    BiomarkerCategoryMembership.transaction do
      # concentrations covers both chemicals and proteins
      puts("filling in concentration biomarker category references")
      all_conc = Concentration.where("exported = true").order(:id)
      check_conc_bmcat(all_conc)
    end
    BiomarkerCategoryMembership.transaction do
      # karyotypes
      puts("filling in karyotype biomarker category references")
      all_karyo = KaryotypeIndication.order(:id)
      check_karyo_bmcat(all_karyo)
    end    
  end

	desc "check to see if the markers given in a tsv files are already present."
	task :check_marker, [:tsv_file,:outfile] => [:environment] do |t, args|
    file_name = args[:tsv_file]
    file_ptr = File.open(file_name,'r')
    file_cont = file_ptr.readlines()
    file_ptr.close()

    out_file_name = args[:outfile]
    matched_file = File.open(File.join(out_file_name,"matched.txt"),'w')
    nomatched_file = File.open(File.join(out_file_name,"No_matched.txt"),'w')

    matched_file.write("original_file\tclass\tname\tmatched_to\tmarkerdb_id\n")
    nomatched_file.write("original_file\tclass\tname\n")

    # file has no header, 1st column is the model class it belongs to (e.g., Protein, SequenceVariant) the second column is the name
    # all proteins
    all_protein = Protein.where("name is not null")
    all_prot_names = Array.new
    all_protein.each do |prot|
      all_prot_names << [prot.name, prot.id]
      prot.aliases.each do |prot_alias|
        all_prot_names << [prot_alias.name, prot.id]
      end
    end

    # all chemicals
    all_chemicals = Chemical.where.not(name: nil)
    all_chem_names = Array.new
    all_chemicals.each do |each_chem|
      all_chem_names << [each_chem.name,each_chem.id]
      each_chem.aliases.each do |chem_alias|
        all_chem_names << [chem_alias.name,each_chem.id]
      end
    end
    # all gene abbreviations
    all_genes = Gene.where.not(gene_symbol: nil)
    all_gene_abbrevs = Array.new
    all_genes.each do |each_gene|
      all_gene_abbrevs << [each_gene.gene_symbol,each_gene.id]
      each_gene.aliases.each do |gene_alias|
        all_gene_abbrevs << [gene_alias.name,each_gene.id]
      end
    end

    ctr = 0
    file_cont.each do |line|
      matched = false
      line = line.split("\t")
      ori_file_name = line[0].strip
      klass = line[1].strip
      marker_name = line[2].strip
      # make it only alphanumeric string and lower case for comparison
      marker_name_stand = marker_name.gsub(/[^0-9a-zA-Z]/i, '').downcase
      if klass.constantize.to_s == "Protein"
        all_prot_names.each do |each_protein_name|
          # do the same for each protein name and its aliases
          each_prot_name_stand = each_protein_name[0].gsub(/[^0-9a-zA-Z]/i, '').downcase
          if marker_name_stand == each_prot_name_stand
            ctr +=1
            matched_file.write("#{ori_file_name}\t#{klass.constantize.to_s}\t#{marker_name}\t#{each_protein_name[0]}\t#{each_protein_name[1].to_s}\n")
            matched = true
            break
          end
        end
        unless matched
          nomatched_file.write("#{ori_file_name}\t#{klass.constantize.to_s}\t#{marker_name}\n")
        end
      elsif klass.constantize.to_s == "Gene"
        all_gene_abbrevs.each do |each_gene_abbrev|
          each_gene_abbrev_stand = each_gene_abbrev[0].gsub(/[^0-9a-zA-Z]/i, '').downcase
          if marker_name_stand == each_gene_abbrev_stand
            matched_file.write("#{ori_file_name}\t#{klass.constantize.to_s}\t#{marker_name}\t#{each_gene_abbrev[0]}\t#{each_gene_abbrev[1].to_s}\n")
            ctr += 1
            matched = true
            break
          end
        end
        unless matched
          nomatched_file.write("#{ori_file_name}\t#{klass.constantize.to_s}\t#{marker_name}\n")
        end
      elsif klass.constantize.to_s == "Chemical"
        all_chem_names.each do |each_chemical|
          each_chemical_stand = each_chemical[0].gsub(/[^0-9a-zA-Z]/i, '').downcase
          if marker_name_stand == each_chemical_stand
            matched_file.write("#{ori_file_name}\t#{klass.constantize.to_s}\t#{marker_name}\t#{each_chemical[0]}\t#{each_chemical[1].to_s}\n")
            ctr += 1
            matched = true
            break
          end
        end
        unless matched
          nomatched_file.write("#{ori_file_name}\t#{klass.constantize.to_s}\t#{marker_name}\n")
        end
      end
    end
    puts(ctr)
    matched_file.close()
    nomatched_file.close()
	end
end