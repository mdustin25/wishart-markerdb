class AddGeneToGeneticBm < ActiveRecord::Migration
  def self.up
    add_column :genetic_bms, :gene, :string
  end

  def self.down
    remove_column :genetic_bms, :gene
  end
end
