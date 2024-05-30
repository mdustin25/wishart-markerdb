class AddApprovalToDiagnosticTest < ActiveRecord::Migration
  def self.up
    add_column :diagnostic_tests, :approval, :string
  end

  def self.down
    remove_column :diagnostic_tests, :approval
  end
end
