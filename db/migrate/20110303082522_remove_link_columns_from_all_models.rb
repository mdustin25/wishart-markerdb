class RemoveLinkColumnsFromAllModels < ActiveRecord::Migration
  def self.up
    remove_column :conditions, :links
    remove_column :diagnostic_tests, :links
  end

  def self.down
    add_column :diagnostic_tests, :links, :string
    add_column :conditions, :links, :string
  end
end
