class CreateMoleculeBms < ActiveRecord::Migration
  def self.up
    create_table :molecule_bms do |t|
      t.string :name
      t.text :description
      t.string :wikipedia_link
      t.string :kegg_link
      t.string :metagene_link
      t.string :pubchem_substance_link
      t.string :pubchem_compound_link
      t.text :pdb_file
      t.text :sdf_file
      t.text :mol_file
      t.string :nugowiki_link
      t.string :biocyc_link
      t.string :bigg_link
      t.string :pdb_link
      t.string :genbank_link
      t.string :omim_link

      t.timestamps
    end
  end

  def self.down
    drop_table :molecule_bms
  end
end
