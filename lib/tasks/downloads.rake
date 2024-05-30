require 'zip'

namespace :downloads do

  desc "Generate all download files for downloads page"
  # rake downloads:generate_all
  task generate_all: [:environment] do
    # Download path to use Wishart gem downloads helper
    DOWNLOAD_PATH = "public/system/downloads/current"
    Dir.mkdir("public/system/downloads/") unless File.exists?("public/system/downloads/")
    Dir.mkdir(DOWNLOAD_PATH) unless File.exists?(DOWNLOAD_PATH)
    
    # protein_marker Download File
    protein_marker_header = %w(id name gene_name uniprot_id conditions indication_types concentration age sex biofluid protein_sequence citation)
    # generate_csv_download_file(DOWNLOAD_PATH, "Protein", protein_marker_header, "id")
    # generate_xml_file_protein(DOWNLOAD_PATH)
    puts("FINISHED PROTEIN MARKERS")
    

    # chemical_marker Download File
    chemical_marker_headers = %w(id name hmdb_id conditions indication_types concentration age sex biofluid citation)
    # generate_csv_download_file(DOWNLOAD_PATH, "Chemical", chemical_marker_headers, "id")
    # generate_xml_file_chemical(DOWNLOAD_PATH)
    puts("FINISHED CHEMICAL MARKERS")
    

    # Karyotype_marker Download file
    karyotype_marker_headers = %w(id karyotype description conditions indication_types)
    # generate_csv_download_file(DOWNLOAD_PATH, "Karyotype", karyotype_marker_headers, "id")
    # generate_xml_file_karyotype(DOWNLOAD_PATH)
    puts("FINISHED KARYOTYPE MARKERS")
    


    # SeqVar marker download file
    seqvar_headers = %w(id variation position external_link gene_symbol entrez_gene_id conditions indication_types reference)
    # generate_csv_download_file(DOWNLOAD_PATH, "SequenceVariant", seqvar_headers, "id")
    # generate_xml_file_SequenceVariant(DOWNLOAD_PATH)
    puts("FINISHED GENETIC MARKERS")
    # abort("GENETIC done")


    # Diagnostic_marker Download file
    diagnostic_marker_headers = %w(biomarker_type)
    generate_csv_download_file(DOWNLOAD_PATH, "Diagnostic", diagnostic_marker_headers, "id")
    puts("FINISHED DIAGNOSTIC MARKERS")
    # abort("seqvar_headers")

    # Predictive_marker Download file
    predictive_marker_headers = %w(biomarker_type)
    generate_csv_download_file(DOWNLOAD_PATH, "Predictive", predictive_marker_headers, "id")
    puts("FINISHED PREDICTIVE MARKERS")

    # Exposure_marker Download file
    exposure_marker_headers = %w(biomarker_type)
    generate_csv_download_file(DOWNLOAD_PATH, "Exposure", exposure_marker_headers, "id")
    puts("FINISHED EXPOSURE MARKERS")

    # Prognostic_marker Download file
    prognostic_marker_headers = %w(biomarker_type)
    generate_csv_download_file(DOWNLOAD_PATH, "Prognostic", prognostic_marker_headers, "id")
    puts("FINISHED PROGNOSTIC MARKERS")

    # # Simulated Populations Download File (zipped)
    # generate_attachment_zip_file(DOWNLOAD_PATH, 'simulated_population')
    # puts("FINISHED SIMULATED POPULATIONS")
  end



  def generate_xml_file_protein(download_path)
    file_name = "#{download_path}/all_proteins.xml"
    xml_file = File.open(file_name, "w")

    xml = Builder::XmlMarkup.new( :indent => 2 )
    xml.instruct! :xml, :encoding => "ASCII"
    xml.version Rails.application.config.version
    xml.proteins do |xml_p|
      Protein.exported.order("id").each do |protein|
        xml_p.protein do |protein_x|
      
          # %w(id name gene_name uniprot_id conditions indication_types concentration age sex biofluid protein_sequence citation)
          protein_x.id protein.id
          protein_x.creation_date protein.created_at
          protein_x.update_date protein.updated_at
          protein_x.name protein.name
          protein_x.gene_name protein.gene_name
          protein_x.uniprot_id protein.uniprot_id

          all_concentrations = Concentration.where("solute_type = \"Protein\" and exported = true and solute_id = ?", protein.id)
          protein_x.conditions do |condition_p|
            
            all_concentrations.each do |each_concentration|
              condition_p.condition do |condition_x|

                condition_x.concentration each_concentration.level.strip()
                condition_x.age  each_concentration.age_range.strip()
                condition_x.sex each_concentration.sex.strip()
                condition_x.biofluid each_concentration.biofluid.strip()
                condition_x.condition  Condition.find_by(:id => each_concentration.condition_id).name.strip()
                condition_x.indication_type BiomarkerCategory.find_by(:id => each_concentration.biomarker_category_id).name
                condition_x.citation get_citation("Concentration",each_concentration.id)

              end
            end
          end
        end
      end
    end
    xml_file.write(xml.to_s)
  end


  def generate_xml_file_chemical(download_path)
    # %w(id name hmdb_id conditions indication_types concentration age sex biofluid citation)
    file_name = "#{download_path}/all_chemicals.xml"
    xml_file = File.open(file_name, "w")

    xml = Builder::XmlMarkup.new( :indent => 2 )
    xml.instruct! :xml, :encoding => "ASCII"
    xml.version Rails.application.config.version
    xml.chemicals do |xml_p|
      Chemical.exported.order("id").each do |chemical|
        xml_p.chemical do |chemical_x|
      
          # %w(id name gene_name uniprot_id conditions indication_types concentration age sex biofluid protein_sequence citation)
          chemical_x.id chemical.id
          chemical_x.creation_date chemical.created_at
          chemical_x.update_date chemical.updated_at
          chemical_x.name chemical.name
          chemical_x.hmdb_id chemical.hmdb

          all_concentrations = Concentration.where("solute_type = \"Chemical\" and exported = true and solute_id = ?", chemical.id)
          
          chemical_x.conditions do |condition_p|
            all_concentrations.each do |each_concentration|
              condition_p.condition do |condition_x|

                condition_x.concentration each_concentration.level.nil?? "N/A" : each_concentration.level.strip()
                condition_x.age  each_concentration.age_range.nil?? "N/A" : each_concentration.age_range.strip()
                condition_x.sex each_concentration.sex.strip()
                condition_x.biofluid each_concentration.biofluid.strip()
                condition_x.condition  Condition.find_by(:id => each_concentration.condition_id).name.strip()
                condition_x.indication_type BiomarkerCategory.find_by(:id => each_concentration.biomarker_category_id).name
                condition_x.citation get_citation("Concentration",each_concentration.id)

              end
            end
          end
        end
      end
    end
    xml_file.write(xml.to_s)
  end

  # %w(id karyotype description conditions indication_types)
  def generate_xml_file_karyotype(download_path)
    file_name = "#{download_path}/all_karyotypes.xml"
    xml_file = File.open(file_name, "w")

    xml = Builder::XmlMarkup.new( :indent => 2 )
    xml.instruct! :xml, :encoding => "ASCII"
    xml.version Rails.application.config.version
    xml.karyotypes do |xml_p|
      Karyotype.exported.order("id").each do |karyotype|
        xml_p.karyotype do |karyotype_x|
          karyotype_x.id karyotype.id
          karyotype_x.karyotype karyotype.karyotype
          karyotype_x.description karyotype.description
          karyotype_x.conditions do |condition_p|
            all_related_conds = KaryotypeIndication.where("karyotype_id = ?",karyotype.id).order(:biomarker_category_id)
            condition_p.condition do |condition_x|
              all_related_conds.each do |each_karyo_cond|
                condition_x.name  Condition.find_by(:id => each_karyo_cond.condition_id).nil?? "N/A" : Condition.find_by(:id => each_karyo_cond.condition_id).name
                condition_x.biomarker_catogory BiomarkerCategory.find_by(:id => each_karyo_cond.biomarker_category_id).nil?? "N/A" : BiomarkerCategory.find_by(:id => each_karyo_cond.biomarker_category_id).name
              end
            end
          end
        end
      end
    end
    xml_file.write(xml.to_s)

  end

  # %w(id variation position external_link gene_symbol entrez_gene_id conditions indication_types reference)
  def generate_xml_file_SequenceVariant(download_path)
    file_name = "#{download_path}/all_sequence_variants.xml"
    xml_file = File.open(file_name, "w")

    xml = Builder::XmlMarkup.new( :indent => 2 )
    xml.instruct! :xml, :encoding => "ASCII"
    xml.version Rails.application.config.version
    xml.sequence_variants do |xml_p|
      SequenceVariant.exported.order("id").each do |seq_var|
        xml_p.sequence_variant do |seq_var_x|
          seq_var_x.id seq_var.id
          seq_var_x.variation seq_var.variation
          seq_var_x.position seq_var.position
          seq_var_x.external_link seq_var.external_url

          seq_var_x.sequence_variant_measurements do |seq_var_p|

            all_seq_var_meas = SequenceVariantMeasurement.where("sequence_variant_id = ?",seq_var.id)
            seq_var_p.sequence_variant_measurement do |sequence_variant_measurement_p|
              all_seq_var_meas.each do |each_all_seq_var_meas|
                sequence_variant_measurement_p.condition Condition.find_by(:id => each_all_seq_var_meas.condition_id).nil?? "N/A" : Condition.find_by(:id => each_all_seq_var_meas.condition_id).name
                sequence_variant_measurement_p.indication_types BiomarkerCategory.find_by(:id => each_all_seq_var_meas.biomarker_category_id).nil?? "N/A" : BiomarkerCategory.find_by(:id => each_all_seq_var_meas.biomarker_category_id).name
              end
            end
          end
        end
      end
    end
    xml_file.write(xml.to_s)
  end
  # Generate a csv format downloads file given a download path, 
  # a list of headers to include, and the model of the headers (in CamelCase)
  def generate_csv_download_file(download_path, model, headers, order)
    # Use a timestamped name so we don't delete the current file until this one is done
    current_time = Time.now.to_i


    # Append translated headers
    rows_array = Array.new
    biomarker_cat = false
    # data_hash = nil
    if model == "Protein"
      rows_array << headers
      prot_data = grab_protein_data_fixed
      prot_data.each do |entry|
        rows_array << entry
      end

    elsif model == "Chemical"
      rows_array << headers
      chem_data = grab_chemical_data_fixed
      chem_data.each do |entry|
        rows_array << entry
      end

    elsif model == "Karyotype"
      rows_array << headers
      karyo_data = grab_karyotype_data(model,headers,order)
      karyo_data.each do |entry|
        rows_array << entry
      end

    elsif model == "SequenceVariant"
      rows_array << headers
      seqvar_data = grab_seqvar_data(model,headers,order)
      seqvar_data.each do |entry|
        rows_array << entry
      end 
    # diagnostic/prognostic/predictive/exposure are not specific ones but types of different markers
    else
      biomarker_cat = true
      prot_headers = %w(id name gene_name uniprot_id conditions indication_types concentration age sex biofluid protein_sequence citation)
      chem_headers = %w(id name hmdb_id conditions indication_types concentration age sex biofluid citation)
      karyo_headers = %w(id karyotype description conditions indication_types)
      seqvar_headers = %w(id variation position external_link gene_symbol entrez_gene_id conditions indication_types)
      data_hash = grab_biomarker_category_data(model,headers,order,prot_headers,chem_headers,karyo_headers,seqvar_headers)
    end    
    if biomarker_cat == true
      data_hash.keys.each do |each_marker_class|
        rows_array = []
        time_path = "#{download_path}/all_#{each_marker_class.underscore.pluralize}-#{current_time}.tsv"
        file_path = time_path.gsub("-#{current_time}", "")
        rows_array += data_hash[each_marker_class]
        # Make the new file
        print_array_to_tsv(time_path, rows_array)

        # Remove existing file (if it exists)
        File.delete(file_path) if File.exists?(file_path)

        # Rename the timestamped file
        File.rename(time_path, file_path)
      end


      # xml
      data_hash.keys.each do |each_marker_class|
        rows_array = []
        time_path = "#{download_path}/all_#{each_marker_class.underscore.pluralize}-#{current_time}.xml"
        file_path = time_path.gsub("-#{current_time}", "")
        rows_array += data_hash[each_marker_class]

        xml_file = File.open(time_path, "w")

        xml = Builder::XmlMarkup.new( :indent => 2 )
        xml.instruct! :xml, :encoding => "ASCII"
        xml.version Rails.application.config.version
        xml.biomarker_type each_marker_class.underscore.pluralize
        xml.biomarkers do |biomarker_x|
          rows_array.each do |row|
            if row.length == 11
              # chemical
              # ["Chemical", 215, "3-Hydroxymethylglutaric acid", "HMDB0000355", "Normal", "Diagnostic", "31.6 (10.4-31.6) umol/mmol creatinine", 
              # "Children", "Both", "Urine", "BC Children's Hospital Biochemical Genetics Lab"]
              biomarker_x.chemical do |final_child|
                final_child.biomarker_type row[0]
                final_child.id row[1]
                final_child.name row[2]
                final_child.hmdb_id row[3]
                final_child.conditions row[4]
                final_child.indication_types row[5]
                final_child.concentration row[6]
                final_child.age row[7]
                final_child.sex row[8]
                final_child.biofluid row[9]
                final_child.citation row[10]
              end
            elsif row.length == 12
              biomarker_x.protein do |final_child|
                final_child.biomarker_type row[0]
                final_child.id row[1]
                final_child.name row[2]
                final_child.gene_name row[3]
                final_child.uniprot_id row[4]
                final_child.conditions row[5]
                final_child.indication_types row[6]
                final_child.concentration row[7]
                final_child.age row[8]
                final_child.sex row[9]
                final_child.biofluid row[10]
                final_child.citation row[11]
              end
            elsif row.length == 6
              # ["biomarker_type", "id", "karyotype", "description", "conditions", "indication_types"]
              biomarker_x.karyotype do |final_child|
                final_child.biomarker_type row[0]
                final_child.id row[1]
                final_child.karyotype row[2]
                final_child.description row[3]
                final_child.conditions row[4]
                final_child.indication_types row[5]
              end
            elsif row.length == 9
              # ["biomarker_type", "id", "variation", "position", "external_link", "gene_symbol", "entrez_gene_id", "conditions", "indication_types"]
              biomarker_x.gene do |final_child|
                final_child.biomarker_type row[0]
                final_child.id row[1]
                final_child.variation row[2]
                final_child.position row[3]
                final_child.external_link row[4]
                final_child.gene_symbol row[5]
                final_child.entrez_gene_id row[6]
                final_child.conditions row[7]
                final_child.indication_types row[8]
              end
            end
          end
        end

        # Remove existing file (if it exists)
        File.delete(file_path) if File.exists?(file_path)

        xml_file.write(xml)

        # Rename the timestamped file
        File.rename(time_path, file_path)

        
      end

    else
      time_path = "#{download_path}/all_#{model.underscore.pluralize}-#{current_time}.tsv"
      file_path = time_path.gsub("-#{current_time}", "")
      # Make the new file
      print_array_to_tsv(time_path, rows_array)

      # Remove existing file (if it exists)
      File.delete(file_path) if File.exists?(file_path)

      # Rename the timestamped file
      File.rename(time_path, file_path)
    end

    # return data_hash
  end

  # Grab gene data
  def grab_seqvar_data(model,headers,order)
    data_array = []
    # for each exported gene entry
    model.constantize.exported.order(order).each do |record|
      row = []
      seq_var_id = "NA"
      headers.each do |header|
        # these have to be obtained from different tables
        next if header == "conditions" or header == "indication_types"
        gene_record = Gene.find(record.gene_id) 
        if header == "id"
          # we need the id for other use
          seq_var_id = record.send(header)
          row.append(record.send(header))
        elsif header == "gene_symbol"
          row.append(gene_record.gene_symbol)
        elsif header == "entrez_gene_id"
          row.append(gene_record.entrez_gene_id)
        elsif header == "external_link"
          row.append(record.send("external_url"))
        else
          row.append(record.send(header))
        end
        # just append each header one at a time
        
      end
      # it will now grab the condition and sequence variant info for this entry
      # it will return 1 entry for each sequence variant
      all_seq_var_meas = SequenceVariantMeasurement.where("sequence_variant_id = ?",seq_var_id)
      if all_seq_var_meas.length > 0
        all_seq_var_meas.each do |each_seq_var_meas|
          condition = "NA"
          indication_types = "NA"
          # each seq_var is its own row
          final_row = row.clone()
          # append the condition associated with its seq_var
          condition = Condition.where("id = ?",each_seq_var_meas.condition_id).first.name
          unless each_seq_var_meas.biomarker_category_id.nil?
            indication_types = BiomarkerCategory.where("id = ?",each_seq_var_meas.biomarker_category_id).first.name
          end
          final_row.append(condition)
          final_row.append(indication_types)
          data_array.append(final_row)
        end
      else
        # if there are no seq_variants (should not happen)
        row.append("NA")
        row.append("NA")
        data_array.append(row)
      end
    end
    return data_array
  end
  # Grab diagnostic data
  def grab_biomarker_category_data(category,base_header,order,prot_headers,chem_headers,karyo_headers,seqvar_headers)
    prot_data = grab_protein_data_fixed # grab_protein_data("Protein",prot_headers,order)
    chem_data = grab_chemical_data_fixed # grab_chemical_data("Chemical",chem_headers,order)
    karyo_data = grab_karyotype_data("Karyotype",karyo_headers,order)
    seqvar_data = grab_seqvar_data("SequenceVariant",seqvar_headers,order)

    data_hash = Hash.new
    # for each data, we check if the indicatino_type is what we want we will add it
    headers = base_header + prot_headers
    protein_array = Array.new
    protein_array << headers
    prot_data.each do |prot_row|
      if prot_row[5] == category
        prot_row.unshift("Protein")
        protein_array << prot_row
      end
    end
    data_hash["#{category}-protein"] = protein_array

    chem_array = Array.new
    headers = base_header + chem_headers
    chem_array << headers
    chem_data.each do |chem_row|
      if chem_row[4] == category
        chem_row.unshift("Chemical")
        chem_array << chem_row
      end
    end
    data_hash["#{category}-chemical"] = chem_array

    karyo_array = Array.new
    headers = base_header + karyo_headers
    karyo_array << headers
    karyo_data.each do |karyo_row|
      if karyo_row[4] == category
        karyo_row.unshift("Karyotype")
        karyo_array << karyo_row
      end
    end
    data_hash["#{category}-karyotype"] = karyo_array

    seq_var_array = []
    headers = base_header + seqvar_headers
    seq_var_array << headers
    seqvar_data.each do |seqvar_row|
      if seqvar_row[7] == category
        seqvar_row.unshift("SequenceVariant")
        seq_var_array << seqvar_row
      end
    end
    data_hash["#{category}-genetics"] = seq_var_array
    data_hash["#{category}"] = chem_array + protein_array + karyo_array + seq_var_array
    return data_hash
  end

  # Grab karyotype data based on headers
  def grab_karyotype_data(model,headers,order)
    data_array = []
    model.constantize.order(order).each do |record|
      row = []
      id = "NA"
      headers.each do |header|
        if header == "id"
          id = record.send(header)
        end
        # since indication_types and conditions are grabbed together, we will skip if it is indication_types
        # these are also grabbed in different tables and will be at the end
        next if header == "indication_types" or header == "conditions"
        # alternate column names
        if header == "description"
          row.append(record.send("ideo_description"))
        else
          row.append(record.send(header))
        end
      end
      # sort by biomarker id so all the diagnostics are together, all the predictions together....
      # each condition will get its own row
      all_related_conds = KaryotypeIndication.where("karyotype_id = ?",id).order(:biomarker_category_id)
      all_related_conds.each do |each_karyo_cond|
        final_row = row.clone()
        cond_name = Condition.where("id = ?",each_karyo_cond.condition_id).first
        biomarker_cat = BiomarkerCategory.where("id = ?",each_karyo_cond.biomarker_category_id).first
        final_row.append(cond_name.name)
        final_row.append(biomarker_cat.name)
        data_array.append(final_row)
      end
    end
    return data_array
  end
  
  # Grab chemical data based on headers
  # id name hmdb_id conditions indication_types concentration age sex biofluid citation
  def grab_chemical_data_fixed
    data_array = Array.new
    Chemical.exported.order("id").each do |chemical|
      all_concentrations = Concentration.where("solute_type = \"Chemical\" and exported = true and solute_id = ?", chemical.id)
      if all_concentrations.length == 0
        content = [chemical.id, chemical.name, chemical.hmdb, "NA", "NA", "NA", "NA","NA", "NA", "NA"]
        data_array << content
      else

        all_concentrations.each do |each_concentration|
          
          condition = "NA"
          concentration = "NA"
          age = "NA"
          sex = "NA"
          biofluid = "NA"
          citation = "NA"
          indication_type = "NA"
          begin
            condition = Condition.find_by(:id => each_concentration.condition_id).name.strip()
          rescue Exception => e
            
          end

          begin
            concentration = each_concentration.level.strip()
          rescue Exception => e
            
          end

          begin
            age = each_concentration.age_range.strip()
          rescue Exception => e
            
          end

          begin
            sex = each_concentration.sex.strip()
          rescue Exception => e
            
          end

          begin
            biofluid = each_concentration.biofluid.strip()
          rescue Exception => e
            
          end

          begin
            indication_type = BiomarkerCategory.find_by(:id => each_concentration.biomarker_category_id).name
          rescue Exception => e
            
          end
          begin
            citation = get_citation("Concentration",each_concentration.id)
          rescue Exception => e
            
          end
          
          content = [chemical.id, chemical.name, chemical.hmdb, condition, indication_type, concentration, age, sex, biofluid, citation]
          data_array << content
        end

      end
    
      
    end

    return data_array
  end

  def grab_chemical_data(model,headers,order)
    data_array = []
    model.constantize.exported.order(order).each do |record|
      row = []
      id = "NA"
      headers.each do |header|
        # these have to be obtained from different tables
        next if header == "indication_types" or header == "citation" or header == "conditions" or header == "concentration" or header == "age" or header == "sex" or header == "biofluid"
        if header == "id"
          id = record.send(header)
        end
        # alternate column names
        if header == "hmdb_id"
          row.append(record.send("hmdb"))
        else
          row.append(record.send(header))
        end
      end
      # it will now grab the concentrations/conditions/age/sex/biolfuid and 1 row for each
      # if header is condition/concentration it has to grab it from elsewhere
      all_concentrations = Concentration.where("solute_type = \"Chemical\" and exported = true and solute_id = ?",id)
      if all_concentrations.length > 0
        all_concentrations.each do |each_concentration|
          condition = "NA"
          concentration = "NA"
          age = "NA"
          sex = "NA"
          biofluid = "NA"
          citation = "NA"
          indication_type = "NA"
          # each concentration is its own row
          final_row = row.clone()
          # append the condition associated with its concentration
          unless each_concentration.condition_id.blank?
            condition = Condition.where("id = ?",each_concentration.condition_id).first.name.strip()
          end
          unless each_concentration.level.blank?
            concentration = each_concentration.level.strip()
          end
          unless each_concentration.age_range.blank?
            age = each_concentration.age_range.strip()
          end
          unless each_concentration.sex.blank?
            sex = each_concentration.sex.strip()
          end
          unless each_concentration.biofluid.blank?
            biofluid = each_concentration.biofluid.strip()
          end
          unless each_concentration.biomarker_category_id.blank?
            indication_type = BiomarkerCategory.where("id = ?",each_concentration.biomarker_category_id).first.name
          end
          # obtain citation
          citation = get_citation("Concentration",each_concentration.id)

          final_row.append(condition)
          final_row.append(indication_type)
          final_row.append(concentration)
          final_row.append(age)
          final_row.append(sex)
          final_row.append(biofluid)
          final_row.append(citation)
          data_array.append(final_row)
        end
      else
        # if there are no concentrations
        row.append("NA")
        row.append("NA")
        row.append("NA")
        row.append("NA")
        row.append("NA")
        row.append("NA")
        row.append("NA")
        data_array.append(row)
      end
    end
    return data_array
  end

  def grab_protein_data_fixed
    data_array = Array.new
    Protein.exported.order("id").each do |protein|
      all_concentrations = Concentration.where("solute_type = \"Protein\" and exported = true and solute_id = ?", protein.id)
      if all_concentrations.length == 0
        content = [protein.id, protein.name, protein.gene_name, protein.uniprot_id, "NA", "NA", "NA", "NA","NA", "NA", "NA"]
        # puts "content => #{content}"
        data_array << content
      else

        all_concentrations.each do |each_concentration|
          
          condition = "NA"
          concentration = "NA"
          age = "NA"
          sex = "NA"
          biofluid = "NA"
          citation = "NA"
          indication_type = "NA"
          begin
            condition = Condition.find_by(:id => each_concentration.condition_id).name.strip()
          rescue Exception => e
            
          end

          begin
            concentration = each_concentration.level.strip()
          rescue Exception => e
            
          end

          begin
            age = each_concentration.age_range.strip()
          rescue Exception => e
            
          end

          begin
            sex = each_concentration.sex.strip()
          rescue Exception => e
            
          end

          begin
            biofluid = each_concentration.biofluid.strip()
          rescue Exception => e
            
          end

          begin
            indication_type = BiomarkerCategory.find_by(:id => each_concentration.biomarker_category_id).name
          rescue Exception => e
            
          end
          begin
            citation = get_citation("Concentration",each_concentration.id)
          rescue Exception => e
            
          end
          
          content = [protein.id, protein.name, protein.gene_name, protein.uniprot_id, condition, indication_type, concentration, age, sex, biofluid, citation]
          data_array << content
        end

      end
    
      
    end

    return data_array

  end
  # Grab protein data based on headers
  def grab_protein_data(model,headers,order)
    data_array = []
    model.constantize.exported.order(order).each do |record|
      row = []
      seq = "NA"
      id = "NA"
      headers.each do |header|
        # these have to be obtained from different tables
        next if header == "indication_types" or header == "citation" or header == "conditions" or header == "concentration" or header == "age" or header == "sex" or header == "biofluid"
        if header == "id"
          id = record.send(header)
        end
        # if it is sequence, we add it at the end of the row
        if header == "protein_sequence"
          seq = record.send(header)
        else
          row.append(record.send(header))
        end
      end
      # it will now grab the concentrations/conditions/age/sex/biolfuid and 1 row for each
      # if header is condition/concentration it has to grab it from elsewhere
      all_concentrations = Concentration.where("solute_type = \"Protein\" and exported = true and solute_id = ?",id)
      if all_concentrations.length > 0
        all_concentrations.each do |each_concentration|
          condition = "NA"
          concentration = "NA"
          age = "NA"
          sex = "NA"
          biofluid = "NA"
          citation = "NA"
          indication_type = "NA"
          # each concentration is its own row
          final_row = row.clone()
          # append the condition associated with its concentration
          unless each_concentration.condition_id.blank?
            condition = Condition.where("id = ?",each_concentration.condition_id).first.name.strip()
          end
          unless each_concentration.level.blank?
            concentration = each_concentration.level.strip()
          end
          unless each_concentration.age_range.blank?
            age = each_concentration.age_range.strip()
          end
          unless each_concentration.sex.blank?
            sex = each_concentration.sex.strip()
          end
          unless each_concentration.biofluid.blank?
            biofluid = each_concentration.biofluid.strip()
          end
          unless each_concentration.biomarker_category_id.blank?
            indication_type = BiomarkerCategory.where("id = ?",each_concentration.biomarker_category_id).first.name
          end
          # obtain citation
          citation = get_citation("Concentration",each_concentration.id)

          final_row.append(condition)
          final_row.append(indication_type)
          final_row.append(concentration)
          final_row.append(age)
          final_row.append(sex)
          final_row.append(biofluid)
          final_row.append(seq)
          final_row.append(citation)
          data_array.append(final_row)
        end
      else
        # if there are no concentrations
        row.append("NA")
        row.append("NA")
        row.append("NA")
        row.append("NA")
        row.append("NA")
        row.append("NA")
        row.append("NA")
        row.append(seq)
        data_array.append(row)
      end
    end
    return data_array
  end
  # obtains citation based on citation_owner_type and owner_id
  def get_citation(citation_owner,citation_owner_id)
    citations = Citation.where("citation_owner_type = ? and citation_owner_id = ?",citation_owner,citation_owner_id)
    all_citation = []
    citations.each do |each_citation|
      # if it is link or textbook, will have citations, if it is pubmed, not necessary
      unless Reference.where("id = ?",each_citation.reference_id).first.citation.nil?
        all_citation.append(Reference.where("id = ?",each_citation.reference_id).first.citation.strip())
      else
        all_citation.append("Pubmed_ID: #{Reference.where("id = ?",each_citation.reference_id).first.pubmed_id}")
      end
    end
    unless all_citation.empty?
      return all_citation.join(";")
    else
      return "NA"
    end
  end
  # Generate a zip file of Paperclip attachments given the download_path and the 
  # attachment name
  def generate_attachment_zip_file(download_path, attachment)
    # Use a timestamped name so we don't delete the current file until this one is done
    current_time = Time.now.to_i
    time_path = "#{download_path}/all_#{attachment.pluralize}-#{current_time}.zip"
    zip_path = time_path.gsub("-#{current_time}", "")

    # Make the new zipfile
    Zip::OutputStream.open(time_path) do |z|
      StudySimulation.exported.each do |study_simulation|
        if study_simulation.send(attachment).present?
          z.put_next_entry(study_simulation.send(attachment + "_file_name")) # file name
          file_data = open(study_simulation.send(attachment).path) # file content
          z.print IO.read(file_data)
        end
      end
    end

    # Remove existing zipfile (if it exists)
    File.delete(zip_path) if File.exists?(zip_path)

    # Rename the timestamped file
    File.rename(time_path, zip_path)
  end

  # Translate an array of headers using en.yml and return the translated header array
  def generate_translated_headers(headers)
    translated_headers = []

    headers.each do |header|
      translated_headers.append(header.titleize)
    end
    return translated_headers
  end

  # Change true/false to Yes/No
  def human_boolean(boolean)
    boolean ? 'Yes' : 'No'
  end

  # Export array of arrays to a CSV file
  def print_array_to_tsv(filename, nested_array)
    # File.open(filename, "w") do |tsv|
    #   nested_array.each do |row|
    #     tsv << "#{row.join("\t")}\n"
    #   end
    # end
    CSV.open(filename, "w", {col_sep: "\t"}) do |csv|
      nested_array.each do |entry|
        csv << entry
      end
    end

  end

end
