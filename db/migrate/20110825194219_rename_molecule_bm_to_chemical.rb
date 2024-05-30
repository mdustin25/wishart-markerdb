class RenameMoleculeBmToChemical < ActiveRecord::Migration
  def self.up
    rename_table :molecule_bms, :chemicals
    remove_index :chemicals, :name => "index_molecule_bms_on_id"
    add_index :chemicals, ["id"]
    rename_table :molecule_bms_molecule_bms, :chemicals_chemicals
    rename_column :chemicals_chemicals, :molecule_bm_id, :chemical_id
  end

  def self.down
    rename_column :chemicals_chemicals, :chemical_id, :molecule_bm_id
    rename_table :chemicals_chemicals, :molecule_bms_molecule_bms
    remove_index :chemicals, :column => ["id"]
    add_index :chemicals, :name => "index_molecule_bms_on_id"
    rename_table :chemicals, :molecule_bms
  end
end
