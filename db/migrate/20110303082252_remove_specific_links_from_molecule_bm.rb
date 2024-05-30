class RemoveSpecificLinksFromMoleculeBm < ActiveRecord::Migration
  def self.up
    change_table :molecule_bms do |t|
      t.remove :wikipedia_link
      t.remove :kegg_link
      t.remove :metagene_link
      t.remove :pubchem_substance_link
      t.remove :pubchem_compound_link
      t.remove :nugowiki_link
      t.remove :biocyc_link
      t.remove :bigg_link
      t.remove :pdb_link
      t.remove :genbank_link
      t.remove :omim_link
    end
  end

  def self.down
    change_table :molecule_bms do |t|
      t.string :wikipedia_link
      t.string :kegg_link
      t.string :metagene_link
      t.string :pubchem_substance_link
      t.string :pubchem_compound_link
      t.string :nugowiki_link
      t.string :biocyc_link
      t.string :bigg_link
      t.string :pdb_link
      t.string :genbank_link
      t.string :omim_link
    end
  end
end
