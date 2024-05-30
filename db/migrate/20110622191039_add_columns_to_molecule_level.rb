class AddColumnsToMoleculeLevel < ActiveRecord::Migration
  def self.up
    add_column :molecule_levels, :mean, :float
    add_column :molecule_levels, :range,:string
    add_column :molecule_levels, :high, :float
    add_column :molecule_levels, :low,  :float
    add_column :molecule_levels, :units,:string
  end

  def self.down
    remove_column :molecule_levels, :units
    remove_column :molecule_levels, :low
    remove_column :molecule_levels, :high
    remove_column :molecule_levels, :range
    remove_column :molecule_levels, :mean
  end
end
