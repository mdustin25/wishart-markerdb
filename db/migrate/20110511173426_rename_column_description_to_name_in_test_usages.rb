class RenameColumnDescriptionToNameInTestUsages < ActiveRecord::Migration
  def self.up
    rename_column :test_usages, :description, :name  
  end

  def self.down
    rename_column :test_usages, :name  , :description
  end
end
