class AddSourceToGeneticBm < ActiveRecord::Migration
  def self.up
    add_column :genetic_bms, :source, :string
  end

  def self.down
    remove_column :genetic_bms, :source
  end
end
