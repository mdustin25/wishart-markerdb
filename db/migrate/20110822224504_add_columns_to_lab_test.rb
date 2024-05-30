class AddColumnsToLabTest < ActiveRecord::Migration
  def self.up
    add_column :lab_tests, :formal_name, :string
    add_column :lab_tests, :lab_test_online_name, :string
  end

  def self.down
    remove_column :lab_tests, :lab_test_online_name
    remove_column :lab_tests, :formal_name
  end
end
