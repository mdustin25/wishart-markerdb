class AddIndexesToEverything < ActiveRecord::Migration
  def self.up
    add_index :allele_aliases, :allele_id
    add_index :alleles, :genetic_bm_id 
    add_index :alleles, :condition_id
    add_index :alleles_diagnostic_tests, :allele_id
    add_index :alleles_references, :reference_id
    add_index :alleles_references, :allele_id
    add_index :bm_levels_diagnostic_tests, :bm_level_id
    add_index :condition_aliases, :condition_id
    add_index :condition_links, :condition_id
    add_index :conditions, :name
    add_index :conditions, :id
    add_index :conditions_genetic_bms, :condition_id
    add_index :conditions_genetic_bms, :genetic_bm_id
    add_index :genetic_bms, :id
    add_index :genetic_bm_aliases, :genetic_bm_id
    add_index :molecule_bm_aliases, :molecule_bm_id
    add_index :molecule_bms, :id
    add_index :molecule_levels, :molecule_bm_id 
    add_index :protein_bm_aliases, :protein_bm_id
    add_index :protein_bms, :id
    add_index :protein_levels, :id
  end

  def self.down
    remove_index :protein_levels, :column => :id
    remove_index :protein_bms, :column => :id
    remove_index :protein_bm_aliases, :column => :protein_bm_id
    remove_index :molecule_levels, :column => :molecule_bm_id
    remove_index :molecule_bms, :column => :id
    remove_index :molecule_bm_aliases, :column => :molecule_bm_id
    remove_index :genetic_bm_aliases, :column => :genetic_bm_id
    remove_index :genetic_bms, :column => :id
    remove_index :conditions_genetic_bms, :column => :genetic_bm_id
    remove_index :conditions_genetic_bms, :column => :condition_id
    remove_index :conditions, :column => :id
    remove_index :conditions, :column => :name
    remove_index :condition_links, :column => :condition_id
    remove_index :condition_aliases, :column => :condition_id
    remove_index :bm_levels_diagnostic_tests, :column => :bm_level_id
    remove_index :alleles_references, :column => :allele_id
    remove_index :alleles_references, :column => :reference_id
    remove_index :alleles_diagnostic_tests, :column => :allele_id
    remove_index :alleles, :column => :condition_id
    remove_index :alleles, :column => :genetic_bm_id
    remove_index :allele_aliases, :column => :allele_id
  end
end
