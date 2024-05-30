class AddDominanceToGeneticBm < ActiveRecord::Migration
  def self.up
    add_column :genetic_bms, :dominance, :string
  end

  def self.down
    remove_column :genetic_bms, :dominance
  end
end
