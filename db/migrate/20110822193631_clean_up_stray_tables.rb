class CleanUpStrayTables < ActiveRecord::Migration
  def self.up
    remove_index "lab_tests_lab_tests", :name => "related_diagnostic_test_index"
    remove_index "biofluids_lab_tests", :name => "index_biofluids_diagnostic_tests_on_biofluid_id"
    remove_index "biofluids_lab_tests", :name => "index_biofluids_diagnostic_tests_on_diagnostic_test_id"
    remove_index "bm_levels_lab_tests", :name => "index_bm_levels_diagnostic_tests_on_bm_level_id"

    drop_table :diagnostic_test_aliases

    rename_column :lab_tests_test_approvals, :diagnostic_test_id, :lab_test_id
    rename_column :lab_tests_test_usages, :diagnostic_test_id, :lab_test_id

    drop_table :alleles_diagnostic_tests
    drop_table :alleles
    drop_table :allele_aliases
    drop_table :alleles_references

  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
