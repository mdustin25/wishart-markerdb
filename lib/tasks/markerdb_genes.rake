namespace :gene do
	task :find_omim_genes => [:environment] do |t|
		gene_list = Array.new
		seq_vars = SequenceVariant.where("exported = true")
		seq_vars.each do |each_seq_var|
			sv_gene = each_seq_var.gene
			unless sv_gene.nil?
				if sv_gene.omim_id.blank? and !gene_list.include?(sv_gene.gene_symbol)
					gene_list << each_seq_var.gene.gene_symbol
				end
			end
		end
		kary_inds = KaryotypeIndication.all()
		kary_inds.each do |each_kary|
			genes = each_kary.gene_list
			genes = genes.split(";").collect{|x| x.strip()}
			genes.each do |each_kary_gene_symbol|
				each_kary_gene = Gene.where("gene_symbol = ?",each_kary_gene_symbol).first
				unless each_kary_gene.nil?
					if each_kary_gene.omim_id.blank? and !gene_list.include?(each_kary_gene.gene_symbol)
						gene_list << each_kary_gene.gene_symbol
					end
				end
			end
		end
		puts(gene_list)
	end
	desc "Run biosummarizer to add genes (based on gene symbol)"
	task :add_genes_biosummarizer, [:tsv,:outfile] => [:environment] do |t, args|
		log = File.open(args[:outfile],'w')
		MarkerDB::Alias
		MarkerDB::Gene
		ptr = File.open(args[:tsv],'r')
		cont = ptr.readlines()
		cont.each do |each_symbol|
			each_symbol = each_symbol.strip()
			Gene.transaction do 
				puts("working on #{each_symbol}")
				protein_data = {'organism' => "Homo Sapiens",
											'symbol_verbatim' => 'true',
											'symbol' => each_symbol}
				summary = BioSummarizer::summarize(protein_data)
				if !summary.nil?
					new_gene = Gene.new(
						description: summary["Description"],
						name: summary["Protein Name"],
						gene_symbol: each_symbol)
					new_gene.save!
					puts("finished #{each_symbol}")
					unless summary["FASTA"].nil?
						fasta = summary["FASTA"].split("\n")
						header = fasta.shift()
						fasta = fasta.join("")
						gene_seq = new_gene.create_gene_sequence(header: "#{new_gene.name.sub(/[\s]/,"_")}_gene",
																				chain: fasta)
						gene_seq.save!
					end
					log.write("#{each_symbol}\t#{new_gene.id}\n")
				end
			end
		end
		log.close()
	end
end