namespace :sequence_variant do
	desc "attach roc curve by seq var ids"
	task :attach_roc_curve_diagnostic_seqvar, [:tsv,:source_dir] => [:environment] do |t, args|
		roc_source_dir = args[:source_dir]
		ptr = File.open(args[:tsv],'r')
		cont = ptr.readlines()
		ptr.close()
		cont.each do |line|
			elem = line.split("\t")
			each_sv_id = elem[1]
			type = elem[0]
			sv = SequenceVariant.find(each_sv_id)
			# will attach a roc curve fo a single Sequence variant as these are diagnostic ones
			# for all its diseases and will have only 1 roc curve.
			svm = SequenceVariantMeasurement.where("sequence_variant_id = ?", sv.id).first
			puts("adding for #{svm.id}, #{sv.id}")
			file_name = "perfect_roc_curve.png"
			roc_obj = RocStats.new(
				roc_auc: 1.0,
				sensitivity: 1.0,
				specificity: 1.0,
				image_file_name: file_name,
				image_content_type: "image/png",
				image_file_size: File.size(File.join(roc_source_dir,"perfect_roc_curve.png"))
				)
			absolute_path = File.join(roc_source_dir,"perfect_roc_curve.png")
			roc_obj.image = open(absolute_path)
			roc_obj.save!
			svm.quality_type = roc_obj.class
			svm.quality_id = roc_obj.id
			svm.biomarker_category_id = 2
			svm.indication_type_id = 1
			svm.save!
			if type == "Both"
				svm.special_constraints = "Cancer biomarkers can be both predictive and diagnostic. The ROC curve shown here is for the diagnosis of the causal mutation for individuals already diagnosed with cancer (i.e. the diagnostic ROC curve).  The ROC curve for this genetic mutation as a predictive marker is not shown."
				svm.save!
			end
		end
	end
	desc "export sequence variants with sequence variant measurements and also export genes with sequence variants"
	task :export_seqvar => [:environment] do |t|
		all_seqvar = SequenceVariant.order(:id)
		SequenceVariant.transaction do
			all_seqvar.each do |seqvar|
				linked_gene = Gene.where("id = ?",seqvar.gene_id).first
				linked_seqvarmeas = SequenceVariantMeasurement.where("sequence_variant_id = ?",seqvar.id).first
				if linked_seqvarmeas.nil?
					unless linked_gene.nil?
						linked_gene.exported = false
						linked_gene.save!
					end
					seqvar.exported = false
					seqvar.save!
				else
					unless linked_gene.nil?
						linked_gene.exported = true
						linked_gene.save!
					end
					seqvar.exported = true
					seqvar.save!
				end
			end
		end
	end
	desc "Populate sequence_variant_measurements with information"
	task :populate_SeqVarMeas => [:environment] do |t|
		SequenceVariantMeasurement.transaction do 
			SequenceVariant.find_each do |seq_var|
				seq_var.sequence_variant_measurements.create!(
					condition_id: seq_var.condition_id, 
					indication_type_id: seq_var.indication_type_id, 
					biomarker_category_id: seq_var.biomarker_category_id,
					indication_modifier: seq_var.indication_modifier,
					)
			end
		end
	end
end