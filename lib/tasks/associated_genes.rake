namespace :karyotype do

  task :associated_gene => [:environment] do
    require 'csv'
    filepath = Rails.root.join("Karyotype.csv")

    CSV.foreach(filepath, :headers => true, encoding: "UTF-8") do |row|

      if row["Associated Genes"].blank?
        next
      end
      gene_list = row['Associated Genes'].split(";")
      karyotype = row['Karyotype']
      
      karyotype = Karyotype.where(karyotype: karyotype).pluck(:id)
      if karyotype.nil?
        next
      end
      gene_list.each do |gene_symbol|
        gene_id = Gene.where(gene_symbol: gene_symbol).pluck(:id)
        if gene_id.blank?
          next
        end
        entry = InvolvedGene.new
        entry.gene_id = gene_id[0]
        entry.karyotype_id = karyotype[0]
        entry.save()
      end
      
    end
    
  end
  
  
end
