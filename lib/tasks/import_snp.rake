namespace :snp do

  task :gwas_import => [:environment] do
    require 'csv'
    filepath = Rails.root.join("final_snp.csv")

    CSV.foreach(filepath, :headers => true, encoding: "UTF-8") do |row|

      condition = row['Condition/Phenotype']

      if is_number?(condition)
        condition_id = condition
      else
        condition = Condition.where(name: condition).first
        if condition.blank?
          next
        else
          condition_id = condition.id
        end
      end

      

      panel_name = row['GWAS-ROCS ID'].concat(" Panel")
      gwas_panel = SequenceVariant.where(variation: panel_name).first
      if gwas_panel.blank?
        gwas_entry = SequenceVariant.new
        gwas_entry.variation = panel_name
        gwas_entry.image_id = row['GWAS-ROCS ID']
        gwas_entry.image_url = "../../../public/system/roc_stats/images/gwas-rocs"

        gwas_entry.biomarker_category_id = '1'
        gwas_entry.marker_type = "SNP Panel"
        gwas_entry.exported = '0'
        gwas_entry.external_url = "https://gwasrocs.ca/study_simulations/".concat(row['GWAS-ROCS ID'])
        gwas_entry.reference = row['PubMed ID']
        gwas_entry.save()
        gwas = SequenceVariant.where(variation: panel_name).first
        gwas_id = gwas.id
        gwas_measure = SequenceVariantMeasurement.new
        gwas_measure.condition_id = condition_id
        gwas_measure.sequence_variant_id = gwas_id
        gwas_measure.approved = "Experimental"
        gwas_measure.clinical_sig = "Pathogenic"
        gwas_measure.logistic_equation = row['Logistic Regression Equation']
        gwas_measure.auroc = row['AUROC']
        gwas_measure.heritability = row['Heritability']
        gwas_measure.save()
        parent = gwas_id 
      else
        parent = gwas_panel.id
      end

      gene = row['Gene']

      gene_object = Gene.where(gene_symbol: gene).first
      if gene_object.blank?
        next
      else
        gene_id = gene_object.id
      end
      
      entry = SequenceVariant.new
      entry.variation = row['Name']
      entry.parent_id = parent
      entry.gene_symbol = gene
      entry.gene_id = gene_id
      entry.reference = row['PubMed ID']
      entry.external_url = "https://gwasrocs.ca/study_simulations/".concat(row['GWAS-ROCS ID'])
      entry.external_type = '[GWAS-ROCS]'
      entry.exported = '1'
      entry.marker_type = "SNP Panel"
      position = row['Position']
      entry.position = position
      chromosome = position.split(":")[0].last
      entry.chromosome = chromosome
      entry.biomarker_category_id = "1"
      entry.save()

      seq_var = SequenceVariant.where(variation: row['Name']).first
      
      entry_measure = SequenceVariantMeasurement.new
      entry_measure.condition_id = condition_id
      entry_measure.clinical_sig = "Pathogenic"
      entry_measure.approved = "Experimental"
      entry_measure.sequence_variant_id = seq_var.id
      entry_measure.save()
       
        
        
        
        
        
        
        
      
      
      
    end
  end

  task :delete_snp => [:environment] do
    SequenceVariant.delete_all
    SequenceVariantMeasurement.delete_all
  end

  task :gtr_import => [:environment] do
    require 'csv'
    filepath = Rails.root.join("gtr_snp.csv")
    count = 0
    needAdding = []
    CSV.foreach(filepath, :headers => true, encoding: "UTF-8") do |row|

      if row['ClinicalSignificance'].equal? "Benign"
        next
      end
      if row['Assembly'].equal? "GRCh37"
        next
      end
      if row['Cytogenetic'].blank?
        next
      end
      condition = row["Phenotype"]
      if is_number?( condition )
        cond_temp = condition
      else
        if Condition.where(name: condition).take.blank? || condition.nil?
          next
        else
          condition_id = Condition.select(:id).where(Condition.arel_table[:name].eq(condition.to_s))
          begin
            condition_id = condition.ids[0].to_i
          rescue
            next
          end
          cond_temp = condition_id
        end
      end
      
      if row['dbSNP'].blank? || row['dbSNP'].include?("-1")
        name = row['Name']
      elsif row['Name'].blank?
        next
      else
        name = row['Name'] + ' ( ' + row['dbSNP'] + ')'
      end
      if name.blank?
        next
      end
      seq_var = SequenceVariant.where(variation: name).first
      unless seq_var.present?
        entry = SequenceVariant.new()
        
        gene = row["GeneSymbol"]
        
        if Gene.where(gene_symbol: gene).take.blank? || gene.nil?
          puts "Gene Not Exist"
          needAdding.push(gene)
          next
        else
          gene_id = Gene.select(:id).where(Gene.arel_table[:gene_symbol].eq(gene.to_s))
          gene_id = gene_id.ids[0].to_i
          entry.gene_id = gene_id
        end
        entry.indication_type_id = '2'
        entry.gene_symbol = gene
        entry.position = row['Cytogenetic']
        entry.chromosome = row['Chromosome']
        entry.variation = name
        entry.variation_sequence = row["Change"]
        entry.external_type = row["#AlleleID"]
        entry.exported = '1'
        entry.biomarker_category_id = '1'
        entry.marker_type = "Single Nucleotide Mutation"
        entry.reference_sequence = row['Change']
        
        unless row['ClinVar_id'].blank?
          entry.external_url = "https://www.ncbi.nlm.nih.gov/clinvar/variation/" + row['ClinVar_id']
          entry.external_type = "[ClinVar]"
        end
        
        entry.save()
      end
      
      seq_var = SequenceVariant.where(variation: name).first
      if seq_var.blank?
        next
      end
      other_measure = SequenceVariantMeasurement.where(sequence_variant_id: seq_var.id).where(condition_id: cond_temp)
      if other_measure.present?
        next
      end
      measure = SequenceVariantMeasurement.new
      measure.condition_id = cond_temp
      measure.sequence_variant_id = seq_var.id
      measure.indication_modifier = "Predictive Marker"
      measure.approved = "Clinically Approved"
      measure.clinical_sig = row['ClinicalSignificance']
      measure.save()
      
      
    end
    puts needAdding
    
  end
end

def is_number? string
  true if Float(string) rescue false
end
