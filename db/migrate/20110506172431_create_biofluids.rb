class CreateBiofluids < ActiveRecord::Migration
  def self.up
    create_table :biofluids do |t|
      t.string :name
    end
    create_table :biofluids_diagnostic_tests, :id => false do |t|
      t.references :biofluid, :diagnostic_test
    end
    add_index :biofluids_diagnostic_tests, :biofluid_id
    add_index :biofluids_diagnostic_tests, :diagnostic_test_id
  end

  def self.down
    drop_table :biofluids
  end
end
