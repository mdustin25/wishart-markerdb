class AddColumnFetchToReferences < ActiveRecord::Migration
  def self.up
    add_column :references, :fetched, :bool
  end

  def self.down
    remove_column :references, :fetched
  end
end
