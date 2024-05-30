class RenameLastOfMissedGeneticBmStuff < ActiveRecord::Migration
  def self.up
    rename_column :sequence_variants, :genetic_bm_id, :gene
    rename_column :genes_genes, :genetic_bm_id, :gene
    remove_index "genes", :name => "index_genetic_bms_on_omim_id"
    remove_index "genes", :name => "index_genetic_bms_on_id"
    add_index "genes", ["id"]
    add_index "genes", ["omim_id"]
  end

  def self.down
    remove_index "genes", :column => ["omim_id"]
    remove_index "genes", :column => ["id"]
    add_index "genes", :name => "index_genetic_bms_on_id"
    add_index "genes", :name => "index_genetic_bms_on_omim_id"
    rename_column :genes_genes, :gene, :genetic_bm_id
    rename_column :sequence_variants, :gene, :genetic_bm_id
  end
end
