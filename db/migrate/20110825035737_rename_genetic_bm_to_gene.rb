class RenameGeneticBmToGene < ActiveRecord::Migration
  def self.up
    drop_table :conditions_genetic_bms
    rename_table :genetic_bms, :genes 
    rename_table :genetic_bms_genetic_bms, :genes_genes
  end

  def self.down
    rename_table :genes_genes, :genetic_bms_genetic_bms
    rename_table :genes , :genetic_bms
    create_table "conditions_genetic_bms", :id => false do |t|
      t.integer "condition_id"
      t.integer "genetic_bm_id"
    end
  end
end
