namespace :seqvar do

  task :indel_dup_import => [:environment] do
    require 'csv'
    filepath = Rails.root.join("gtr_other.csv")

    CSV.foreach(filepath, :headers => true, encoding: "UTF-8") do |row|

      if row['Cytogenetic'].blank?
        next
      end
      condition = row["Phenotype"]
      if is_number?( condition )
        cond_temp = condition
      else
        if Condition.where(name: condition).first.blank? || condition.nil?
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

      if row['Name'].blank?
        next
      else
        name = row['Name'].split(":")[1]
      end
      seq_var = SequenceVariant.where(variation: name).first
      unless seq_var.present?
        entry = SequenceVariant.new()

        gene = row["GeneSymbol"]

        if Gene.where(gene_symbol: gene).take.blank? || gene.nil?
          puts "Gene Not Exist"
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
        entry.external_type = row["#AlleleID"]
        entry.variation_sequence = row['Change']
        entry.exported = '1'
        entry.biomarker_category_id = '1'
        variant_type = row['Type']
        if variant_type.blank?
          next
        else
          entry.marker_type = variant_type.capitalize
        end
          
              
        

        entry.variation_sequence = row['Change']

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
    
  end

  task :seqvar_pubmed => [:environment] do
    require 'csv'
    filepath = Rails.root.join("var_citations.csv")

    CSV.foreach(filepath, :headers => true, encoding: "UTF-8") do |row|

      allele = row["#AlleleID"]
      cite_source = row["citation_source"]
      cite_id = row["citation_id"]
      unless cite_source == "PubMed"
        
        next
      end

      link = '<a href="https://pubmed.ncbi.nlm.nih.gov/#{cite_id}">PMID: #{cite_id} <a>'
      
      seq_var = SequenceVariant.where(external_type: allele).first
      
      unless seq_var.blank?
        current_citation = seq_var.external_url
        if current_citation.blank?
          seq_var.update(external_url: link)
        else
          current_citation.concat(", ")
          current_citation.concat(link)
          seq_var.update(external_url: current_citation)

        end
      end
      
    end
    
  end
end

def is_number? string
  true if Float(string) rescue false
end
