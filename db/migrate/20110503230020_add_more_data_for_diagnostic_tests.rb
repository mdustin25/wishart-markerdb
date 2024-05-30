class AddMoreDataForDiagnosticTests < ActiveRecord::Migration
  def self.up
    create_table :test_approvals do |t|
      t.string :description
    end
    create_table  :diagnostic_tests_test_approvals, :id=>false do |t|
      t.references :diagnostic_test, :test_approval
    end
    create_table :test_usages do |t|
      t.string :description
    end
    create_table :diagnostic_tests_test_usages, :id=>false do |t|
      t.references :diagnostic_test, :test_usage
    end
    add_column :diagnostic_tests, :fda_search_term, :string 
    remove_column :diagnostic_tests, :approval
  end

  def self.down
    add_column :diagnostic_tests, :approval, :string
    remove_column :diagnostic_tests, :fda_search_term
    drop_table :diagnostic_tests_test_usages
    drop_table :test_usages
    drop_table :diagnostic_tests_test_approvals
    drop_table :test_approvals
  end
end
