class RenameProteinBmToProtein < ActiveRecord::Migration
  def self.up
    rename_table :protein_bms, :proteins
    remove_index "proteins", :name => "index_protein_bms_on_id"
    add_index "proteins", ["id"]
    rename_table :protein_bms_protein_bms, :proteins_proteins
    rename_column :proteins_proteins, :protein_bm_id, :protein_id
    drop_table :protein_levels
  end

  def self.down
    create_table :protein_levels do |t|
    end
    rename_column :proteins_proteins, :protein_id, :protein_bm_id
    rename_table :proteins_proteins, :protein_bms_protein_bms
    remove_index "proteins", :column => ["id"]
    add_index "proteins", :name => "index_protein_bms_on_id"
    rename_table :proteins, :protein_bms
  end
end
