class AddOmimTypeToGeneticBm < ActiveRecord::Migration
  def self.up
    add_column :genetic_bms, :omim_type, :string
  end

  def self.down
    remove_column :genetic_bms, :omim_type
  end
end
