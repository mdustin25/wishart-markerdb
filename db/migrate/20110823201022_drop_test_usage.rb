class DropTestUsage < ActiveRecord::Migration
  def self.up
    drop_table "lab_tests_test_usages"
    drop_table :test_usages
  end

  def self.down
    create_table :test_usages do |t|
      t.string "name"
    end
    create_table "lab_tests_test_usages", :id => false do |t|
      t.integer "lab_test_id"
      t.integer "test_usage_id"
    end
  end
end
