namespace :karyotype do

  task :delete_indications => [:environment] do
    KaryotypeIndication.delete_all
    
  end
  task :try_out => [:environment] do |t|
    chromosome_pos = []
    applicable_filters = ["1","2"]
    applicable_filters.each do |applicable_filter|
      karyotypes = Karyotype.where("exported = true")
      karyotypes.each do |each_karyo|
        chrom_involved = each_karyo.chromosome_involved.split(";")
          puts(chrom_involved)
          puts(applicable_filter)
          STDIN.gets()
        if chrom_involved.include?(applicable_filter)
          chromosome_pos << each_karyo.id
        end
      end
      puts(chromosome_pos)
    end

  end
  task :update_karyotype => [:environment] do
    ActiveRecord::Base.connection.execute('UPDATE karyotypes SET karyotype="Trisomy 4" WHERE karyotype=4;')
    ActiveRecord::Base.connection.execute('UPDATE karyotypes SET karyotype="Trisomy 11" WHERE karyotype=11;')
    ActiveRecord::Base.connection.execute('UPDATE karyotypes SET karyotype="Trisomy 13" WHERE karyotype=13;')
    ActiveRecord::Base.connection.execute('UPDATE karyotypes SET karyotype="Trisomy 21" WHERE karyotype=21;')
    ActiveRecord::Base.connection.execute('UPDATE karyotypes SET karyotype="Trisomy 22" WHERE karyotype=22;')
  end

  
  task :update_description => [:environment] do
    require 'csv'
    filepath = Rails.root.join("Karyotype.csv")

    CSV.foreach(filepath, :headers => true, encoding: "UTF-8") do |row|

      description = row['Description']
      if description.blank?
        puts "here"
        next
      end
      karyotype = row['Karyotype']

      entry = Karyotype.where("karyotype = ?", karyotype).first
      if entry.blank?
        puts karyotype
        next
      end
      entry.update(description: description)

    end
      
    
  end
  
  task :delete_unreferenced => [:environment] do
    Karyotype.where('id NOT IN (SELECT DISTINCT(karyotype_id) FROM karyotype_indications)').delete_all
  end 
  

  task :import_conditions => [:environment] do
    require 'csv'
    filepath = Rails.root.join("ConditionsAdd.csv")

    CSV.foreach(filepath, :headers => true, encoding: "UTF-8") do |row|

      condition = row["Condition"]
      superCon = row["super?"]
      omim = row["OMIM"]
      conCat = row["Condition Category"]

      entry = Condition.new
      entry.name = condition
      unless superCon.blank?
        super_id = Condition.where(name: superCon).pluck(:id)
        puts super_id
        entry.super_condition_id = super_id
      end

      unless omim.blank?
        entry.omim_records = omim.split()
      end
      entry.description = row["description"]
      entry.exported = "1"
      entry.save()

      con = Condition.where(name: condition).pluck(:id)[0]

      ActiveRecord::Base.connection.execute("INSERT INTO condition_categories_conditions (condition_category_id, condition_id) VALUES (#{conCat}, #{con});")

      
      
    end
  end

  task :import_karyotype => [:environment] do
    require 'csv'
    filepath = Rails.root.join("Karyotype.csv")

    CSV.foreach(filepath, :headers => true, encoding: "UTF-8") do |row|
      
      karyotype = row['Karyotype']
      assocGenes = row['Associated Genes']
      conditions = row['Disease']
      citation = row['Citation']
      if conditions.blank?
        puts karyotype
        next
      end
      sex = row['Sex']
      unless sex.blank?
        sex = sex.capitalize
      end
      age = row['Age']
      age_entry = ""

      unless age.blank?
        age_list = age.split(";")
        age_list.each_with_index do |a, index|
          
          if a.blank?
            next
          end
          if a.include?("adult") || a.include?("Adult")
            age_entry = age_entry + "Adult(18-65 yrs old)"
            puts "makes it"
          elsif a.include? "adolescent"
            age_entry = age_entry + "Adolescent(13-18 yrs old)"
          elsif a.include? "child"
            age_entry = age_entry + "Children(2-12 yrs old)"
          elsif a.include? "infants"
            age_entry = age_entry + "Infant(0-1 yrs old)"
          elsif a.include? "in utero"
           age_entry = age_entry + "In Utero"
          elsif a.include?("elder") || a.equal?("elderly")
            age_entry = age_entry + "Elderly( >65 yrs old)"
          end
          unless index == age_list.size - 1
            age_entry.concat(", ")
          end
        end
      end
      
      filename = karyotype + ".png"
      temp = Karyotype.where(karyotype: karyotype).first
      if temp.blank?
        temp = Karyotype.new
        temp.karyotype = karyotype
        temp.diagram_file_name = filename
        temp.exported = "1"
        temp.save()
      end
      karyotype_id = Karyotype.where(karyotype: karyotype).first.id
      if karyotype_id.blank?
        next
      end
      condition_list = conditions.split(";")
      condition_list.each do |condition|
        
        entry = KaryotypeIndication.new
        if is_number? condition
          entry.condition_id = condition
          
        else
          condition_id = Condition.where(name: condition).where(exported: "1").first
          if condition_id.blank?
            puts row["Disease"]
            next
          else
            condition_id = condition_id.id
            entry.condition_id = condition_id
          end
        end
        if assocGenes.blank?
          assocGenes = "N/A"
        end
        entry.gene_list = assocGenes
        entry.age = age_entry
        entry.sex = sex
        entry.citation = citation
        entry.exported = "1"
        entry.karyotype_id = karyotype_id
        
        entry.biomarker_category_id = "2"
        entry.indication_type_id = "1"
        entry.save()
      end
      
    end
    
  end

   
  
end
   
def is_number? string
  true if Float(string) rescue false
end
