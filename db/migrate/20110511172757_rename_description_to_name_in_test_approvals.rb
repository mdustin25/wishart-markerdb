class RenameDescriptionToNameInTestApprovals < ActiveRecord::Migration
  def self.up
    rename_column :test_approvals, :description, :name
  end

  def self.down
    rename_column :test_approvals, :name, :description
  end
end
