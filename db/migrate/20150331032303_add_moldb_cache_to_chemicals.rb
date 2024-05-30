class AddMoldbCacheToChemicals < ActiveRecord::Migration

  def self.up
    change_table :chemicals do |t|
      t.text :moldb_smiles 
      t.string :moldb_formula 
      t.text :moldb_inchi 
      t.string :moldb_inchikey 
      t.text :moldb_iupac 
      t.string :moldb_logp 
      t.string :moldb_pka 
      t.string :moldb_average_mass 
      t.string :moldb_mono_mass 
      t.string :moldb_alogps_solubility 
      t.string :moldb_alogps_logp 
      t.string :moldb_alogps_logs 
      t.string :moldb_acceptor_count 
      t.string :moldb_donor_count 
      t.string :moldb_rotatable_bond_count 
      t.string :moldb_polar_surface_area 
      t.string :moldb_refractivity 
      t.string :moldb_polarizability 
      t.text :moldb_traditional_iupac 
      t.integer :moldb_formal_charge 
      t.integer :moldb_physiological_charge 
      t.string :moldb_pka_strongest_basic 
      t.string :moldb_pka_strongest_acidic 
      t.string :moldb_bioavailability 
      t.integer :moldb_number_of_rings 
      t.boolean :moldb_rule_of_five 
      t.boolean :moldb_ghose_filter 
      t.boolean :moldb_veber_rule 
      t.boolean :moldb_mddr_like_rule 
    end
  end

  def self.down
    change_table :chemicals do |t|
      t.remove :moldb_smiles 
      t.remove :moldb_formula 
      t.remove :moldb_inchi 
      t.remove :moldb_inchikey 
      t.remove :moldb_iupac 
      t.remove :moldb_logp 
      t.remove :moldb_pka 
      t.remove :moldb_average_mass 
      t.remove :moldb_mono_mass 
      t.remove :moldb_alogps_solubility 
      t.remove :moldb_alogps_logp 
      t.remove :moldb_alogps_logs 
      t.remove :moldb_acceptor_count 
      t.remove :moldb_donor_count 
      t.remove :moldb_rotatable_bond_count 
      t.remove :moldb_polar_surface_area 
      t.remove :moldb_refractivity 
      t.remove :moldb_polarizability 
      t.remove :moldb_traditional_iupac 
      t.remove :moldb_formal_charge 
      t.remove :moldb_physiological_charge 
      t.remove :moldb_pka_strongest_basic 
      t.remove :moldb_pka_strongest_acidic 
      t.remove :moldb_bioavailability 
      t.remove :moldb_number_of_rings 
      t.remove :moldb_rule_of_five 
      t.remove :moldb_ghose_filter 
      t.remove :moldb_veber_rule 
      t.remove :moldb_mddr_like_rule 
    end
  end
end
