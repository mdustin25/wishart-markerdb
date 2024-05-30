
mapper = XMLMapper.build_mapper_for GeneticBm do

  m :entrez_gene_id, "//Gene-track/Gene-track_geneid"
  m :genetic_type, "//Entrezgene_type", :attr => :value

  section "//BioSource/BioSource_org" do
    m :source_taxname, "//Org-ref_taxname"
    m :source_common, "//Org-ref_common"

    association :external_links, "//Org-ref_db/Dbtag" do 
      m :key, "Db_tag_tag//Object-id_id" 
      m :link_type_name, "Db_tag_db"
    end
  end

  section "//Entrezgene_gene/Gene-ref" do
    m :gene, "Gene-ref_locus"
    m :name, "Gene-ref_desc"
    
    association :external_links, "Gene-ref_db"  do 
      m :key, "Db_tag_tag//Object-id_id"
      m :link_type_name, "Dbtag_db"
    end

    association :aliases, "Gene-ref_syn" do
      m :name, "Gene-ref_syn_E"
    end
  end

  section "//Entrezgene_prot/Prot-ref" do
    association :aliases, "//Prot-ref_name_E" do
      m :name, "."
    end
  end

  m :description, "//Entrezgene_summary"
  m :position, "//Entrezgene_location//Maps_display-str"

end


def import_objects(objects)
  puts "importing #{objects.size} objects"
  columns = [
    :name,
    :description,
    :genetic_type,
    :position,
    :updated_at,
    :dominance,
    :source_common,
    :gene,
    :source_taxname,
    :entrez_gene_id
  ]

  grouped_objects = objects.group_by(&:class)

  GeneticBm.import grouped_objects[GeneticBm], 
    :on_duplicate_key_update => columns
  grouped_objects.delete GeneticBm

  grouped_objects.each_pair do |klass, objects_to_import|
    klass.import objects_to_import
  end
  puts "import done"
end

all_files = Dir.glob( File.expand_path("~/marker_db/missing_disease_genes/*") )
all_objects = []

progress = ProgressBar.new("parsing", all_files.count)
all_files.each do |file_name|

  file = File.open(file_name,"r")
  doc = Nokogiri::XML(file)

  genetic_bm = GeneticBm.create

  result = mapper.update genetic_bm, doc
  all_objects += result.mapped_objects

  progress.inc
end
progress.finish


import_objects all_objects

