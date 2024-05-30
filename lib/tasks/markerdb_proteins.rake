namespace :protein do 
  desc "moved protein aa sequences to polypeptides model for seqsearch gem"
  task :move_aa_sequence => [:environment] do |t|
    Protein.transaction do
      all_prot_wSequences = Protein.where.not(protein_sequence: [nil,""])
      all_prot_wSequences.each do |each_prot|
        each_prot.create_polypeptide_sequence(header: each_prot.name,chain: each_prot.protein_sequence)
      end
      Protein.find_each do |each_protein|
        each_protein.exported = true
        each_protein.save!
      end
    end
  end
  desc "obtain structure based on protein ids in tsv file"
  task :obtain_structure_from_tsv, [:tsv] => [:environment] do |t, args|
    ptr = File.open(args[:tsv],'r')
    cont = ptr.readlines
    cont.each do |each_id|
      prot = Protein.find(each_id)
      pdbid = prot.structure_image_pdb_id
      prot.structure_image = open("https://www.rcsb.org/pdb/images/#{pdbid}_bio_r_500.jpg")
      prot.save!
    end
  end

  desc "set protein markers to 'single' as marker type since all are at the moment"
  task :set_single_panel => [:environment] do |t|
    prot = Protein.where("exported = true")
    prot.each do |each_prot|
      each_prot.panel_single = "single"
      each_prot.save!
    end
  end

  desc "populate sequences uniprot id with protein table uniprot id"
  task :move_uniprot_id => [:environment] do |t|
    # sequences uniprot id will replace proteins uniprot id
    prot = Protein.where("exported = true")
    prot.each do |each_prot|
      each_prot.polypeptide_sequences.each do |each_polypep|
        if each_polypep.uniprot_id.nil?
          each_polypep.uniprot_id = each_prot.uniprot_id
          each_polypep.save!
        end
      end
    end
  end
  desc "export protein with concentrations"
  task :export_prot => [:environment] do |t|
    all_prot = Protein.order(:id)
    all_prot.each do |each_prot|
      linked_concentration = Concentration.where("solute_type = \"Protein\" and exported = true and solute_id = ? ",each_prot.id)
      if linked_concentration.length > 0
        each_prot.exported = true
        each_prot.save!
      else
        each_prot.exported = false
        each_prot.save!
      end
    end
  end
end