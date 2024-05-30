class AddOmimIdToGeneticBm < ActiveRecord::Migration
  def self.up
    add_column :genetic_bms, :omim_id, :integer
    add_index :genetic_bms, :omim_id 
  end

  def self.down
    remove_index :genetic_bms, :column => :omim_id
    remove_column :genetic_bms, :omim_id
  end
end
