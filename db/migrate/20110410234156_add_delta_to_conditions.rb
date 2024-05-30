class AddDeltaToConditions < ActiveRecord::Migration
  def self.up
    add_column :conditions, :delta, :boolean, :default => true, :null => false
  end

  def self.down
    remove_column :conditions, :delta
  end
end
