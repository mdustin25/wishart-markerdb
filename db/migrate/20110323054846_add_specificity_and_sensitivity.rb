class AddSpecificityAndSensitivity < ActiveRecord::Migration
  def self.up
    add_column :alleles, :specificity, :string
    add_column :alleles, :sensitivity, :string
    add_column :genetic_bms, :specificity, :string
    add_column :genetic_bms, :sensitivity, :string
    add_column :molecule_levels, :specificity, :string
    add_column :molecule_levels, :sensitivity, :string
    add_column :protein_levels, :specificity, :string
    add_column :protein_levels, :sensitivity, :string
  end

  def self.down
    remove_column :protein_levels, :sensitivity
    remove_column :protein_levels, :specificity
    remove_column :molecule_levels, :sensitivity
    remove_column :molecule_levels, :specificity
    remove_column :genetic_bms, :sensitivity
    remove_column :genetic_bms, :specificity
    remove_column :alleles, :sensitivity
    remove_column :alleles, :specificity
  end
end
