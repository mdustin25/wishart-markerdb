namespace :import_anchi do

  #bundle exec rake import_anchi:add_gene
  desc "update disease descriptions"
  task :update_disease_descriptions => [:environment] do
    Condition.transaction do
      CSV.open("data/disease_descriptions.tsv", "r", :col_sep => "\t", quote_char: "|").each do |row|
        disease, desc = row
        puts "#{disease}"
        #g = Condition.find_by(name: disease)
        cond = Condition.where(name: disease)
        cond.each do |g|
        #if !g.nil?
          g.name = disease
          g.description = desc
          g.save!
          puts "Updated!"
        #else
          #puts "Condition #{disease} not found"
        end

      end
    end
  end

  task :add_gene => [:environment] do
    Gene.transaction do
      CSV.open("data/diseases_genes_primers.tsv", "r", :col_sep => "\t").each do |row|
        disease, source, organism, name, marker_type, gene_symbol, header, seq, comments, reference = row
        puts "#{disease}.  #{reference}"
        g = Gene.find_by(gene_symbol: gene_symbol)
        if g.nil?
          g = Gene.new
          g.gene_symbol = gene_symbol
          g.name = name
          g.genetic_type = "protein-coding"
          g.exported=1
          g.save!
        else
          puts "Gene #{gene_symbol} ---#{g.gene_symbol}--- already exists"
        end

      end
    end
  end

  #bundle exec rake import_anchi:add_condition RAILS_ENV=production
  desc "add condition"
  task :add_condition => [:environment] do
    Condition.transaction do
      CSV.open("data/diseases_genes_primers.tsv", "r", :col_sep => "\t").each do |row|
        disease, source, organism, name, marker_type, gene_symbol, header, seq, comments, reference = row
        puts "#{disease}.  #{reference}"
        g = Condition.find_by(name: disease)
        if g.nil?
          g = Condition.new
          g.name = disease
          g.exported=1
          g.save!
        else
          puts "Condition #{disease} ---#{g.name}--- already exists"
        end

      end
    end
  end

  desc "add condition category"
  task :add_condition_category => [:environment] do
    Condition.transaction do
      CSV.open("data/condition_categ.tsv", "r", :col_sep => "\t").each do |row|
        disease, category = row
        puts "#{disease}  #{category}"

        cc = ConditionCategory.find_by(name: category)
        puts "cc #{cc.id}"
        c = Condition.find_by(name: disease)
        puts "c #{c.id}"

        # if !c.nil? and !cc.nil?
        #   ConditionCategoryCondition.condition_id = c.id
        #   ConditionCategoryCondition.condition_category_id = cc.id
        # else
        #   puts "Condition #{cc.id} ---#{c.name}--- already exists"
        # end

      end
    end
  end

  desc "add condition and category"
  task :add_condition_and_category => [:environment] do
    Condition.transaction do
      CSV.open("data/conditions.tsv", "r", :col_sep => "\t").each do |row|
        condition, category_id, description = row
        puts "#{condition}  #{category_id}"
        cond = "#{condition}"
        if cond == "condition"
          next
        end
        cc = ConditionCategory.find_by_id(category_id)

        puts "#{condition}  #{cond}.  #{category_id}"
        c = Condition.find_by(name: condition)
        if c.nil?
          c = Condition.new
          c.name = cond
          c.description = description
          if !cc.nil?
            c.categories << cc
          end
          c.exported = 1
          c.save!
          puts "#{cond} added!"
        else
          puts "#{cond} already exists!"
          next
        end
        # if !c.nil?
        #   ccc = ConditionCategoryCondition.new
        #   ccc = ConditionCategoryCondition.new
        #   ccc.condition_id = c.id
        #   ccc.condition_category_id = category_id
        #   ccc.save!
        # else
        #   puts "Can't add condition category"
        # end

      end
    end
  end

  desc "add condition descriptions"
  task :add_condition_descriptions => [:environment] do
    Condition.transaction do
      CSV.open("data/exposure_descriptions_2.tsv", "r", :col_sep => "\t", quote_char: "|").each do |row|
        cond_id, condition, desc = row
        puts "#{cond_id}  #{condition}"

        c = Condition.find_by_id(cond_id)
        puts "c #{c.id}"

        if !c.nil?
           c.description = desc
           c.save!
        else
           puts "Condition #{c.id} ---#{c.name}--- is not found"
        end

      end
    end
  end

  #bundle exec rake import_anchi:add_sequence_variants
  desc "add gene sequence"
  task :add_sequence_variants => [:environment] do
    SequenceVariant.transaction do
      CSV.open("data/diseases_genes_primers.tsv", "r", :col_sep => "\t").each do |row|
        disease, source, organism, name, marker_type, gene_symbol, header, seq, comments, reference = row
        puts "#{gene_symbol}  #{header}. #{seq}"

        gene = Gene.find_by(gene_symbol: gene_symbol)
        sv = SequenceVariant.find_by(gene_symbol: gene_symbol, source: source, organism: organism)
        ggs = gene.gene_sequences.find_by(header: header, sequenceable_type: "Gene", chain: seq, sequenceable_id: gene.id)

        if !gene.nil? and sv.nil?
          sv = SequenceVariant.new
          sv.source = source
          sv.organism = organism
          sv.gene_symbol = gene_symbol
          sv.gene_id = gene.id
          sv.biomarker_category_id = 2
          sv.marker_type = marker_type
          sv.reference = reference
          sv.save!
        elsif gene.nil?
          puts "Not saved! Gene #{gene_symbol} not found"
        elsif !sv.nil?
          puts "Not saved! SequenceVariant #{sv.id} already exists"
        end

        if !gene.nil? and ggs.nil?
          gs = gene.gene_sequences.create()
          gs.type = "GeneSequence"
          gs.sequenceable_id = gene.id
          gs.sequenceable_type = "Gene"
          gs.header = header
          gs.chain = seq
          gs.save!
        elsif gene.nil?
          puts "Not saved! Gene #{gene_symbol} not found"
        elsif !ggs.nil?
          puts "Not saved! sequences #{ggs.id} already exists"
        end

      end
    end
  end

  #bundle exec rake import_anchi:add_sequence_variants
  desc "add sequence variant measurements"
  task :add_sequence_variant_measurements => [:environment] do
    SequenceVariant.transaction do
      CSV.open("data/diseases_genes_primers.tsv", "r", :col_sep => "\t").each do |row|
        disease, source, organism, name, marker_type, gene_symbol, header, seq, comments, reference = row
        #puts "#{gene_symbol}  #{header}. #{seq}"

        c = Condition.find_by(name: disease)
        sq = GeneSequence.find_by(chain: seq, header: header, sequenceable_type: "Gene")

        if !sq.nil?
           
          sv = SequenceVariant.find_by(gene_symbol: gene_symbol, source: source, organism: organism, gene_id: sq.sequenceable_id)
          
          if !sv.nil? and !c.nil?
              puts "SV id #{sv.id}"
              svm = SequenceVariantMeasurement.new
              svm.condition_id = c.id
              svm.sequence_variant_id = sv.id
              if reference != /www/
                puts "PMID"
                svm.pubmed_id = reference
              else
                puts "~~~~~ Not PMID~~~~~"
              end
              svm.save!
          elsif sv.nil?
            puts "Seq Variant #{gene_symbol}. #{header}. #{seq} not found"
          elsif c.nil?
            puts "Condition #{disease} is not found"        
          end
        end
      end       
    end
  end

  desc "remove duplcate condition"
  task :remove_condition => [:environment] do
    Condition.transaction do
      CSV.open("data/duplicate_conditions_to_delete.tsv", "r", :col_sep => "\t").each do |row|
        id,condition, sth = row
        puts "#{condition}"
        if t = Condition.find_by_id(id)
          puts "#{condition}. #{t.name}"
          t.destroy!
          puts "Deleted!"
        end
      end
    end
  end

  #bundle exec rake import_anchi:remove_sequences
  desc "remove sequences"
  task :remove_sequences => [:environment] do
    GeneSequence.transaction do
      CSV.open("data/primer_sequences_to_delete.tsv", "r", :col_sep => "\t").each do |row|
        id, chain = row
        puts "#{id}"
        if t = GeneSequence.find_by_id(id)
          puts "#{id}. #{t.chain}.  #{chain}"
          t.destroy!
          puts "Deleted!"
        end
      end
    end
  end

end

