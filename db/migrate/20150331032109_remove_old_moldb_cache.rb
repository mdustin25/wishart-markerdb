class RemoveOldMoldbCache < ActiveRecord::Migration

  def self.down
    change_table :chemicals do |t|
      t.integer :moldb_id 
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
      t.string :moldb_traditional_iupac 
      t.integer :moldb_formal_charge 
    end
  end

  def self.up
    change_table :chemicals do |t|
      t.remove :moldb_id 
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
    end
  end
end
