class RenameDiagnosticTests < ActiveRecord::Migration
  def self.up
    rename_table :biofluids_diagnostic_tests, :biofluids_lab_tests
    rename_column :biofluids_lab_tests, :diagnostic_test_id, :lab_test_id
    add_index "biofluids_lab_tests", ["biofluid_id"]
    add_index "biofluids_lab_tests", ["lab_test_id"]

    rename_table :bm_levels_diagnostic_tests, :bm_levels_lab_tests
    rename_column :bm_levels_lab_tests, :diagnostic_test_id, :lab_test_id
    add_index "bm_levels_lab_tests", ["bm_level_id"]

    rename_table :diagnostic_test_ownerships, :lab_test_ownerships
    rename_column :lab_test_ownerships, :diagnostic_test_owner_id, :lab_test_owner_id
    rename_column :lab_test_ownerships, :diagnostic_test_owner_type, :lab_test_owner_type
    rename_column :lab_test_ownerships, :diagnostic_test_id, :lab_test_id

    rename_table :diagnostic_tests, :lab_tests
    rename_table :diagnostic_tests_diagnostic_tests, :lab_tests_lab_tests
    rename_column :lab_tests_lab_tests, :diagnostic_test_id, :lab_test_id
    add_index "lab_tests_lab_tests", ["lab_test_id", "related_id"], :name => "related_lab_test_index"

    drop_table :diagnostic_tests_genetic_bms
    drop_table :diagnostic_tests_molecule_bms
    drop_table :diagnostic_tests_protein_bms
    drop_table :diagnostic_tests_molecule_levels
    drop_table :diagnostic_tests_protein_levels
    drop_table :diagnostic_tests_references

    rename_table :diagnostic_tests_test_approvals, :lab_tests_test_approvals
    rename_table :diagnostic_tests_test_usages, :lab_tests_test_usages

    rename_column :fda_kits, :diagnostic_test_id, :lab_test_id
  end

  def self.down
    rename_column :fda_kits, :lab_test_id, :diagnostic_test_id

    rename_table :lab_tests_test_usages, :diagnostic_tests_test_usages
    rename_table :lab_tests_test_approvals, :diagnostic_tests_test_approvals

    create_table :diagnostic_tests_references do |t|
    end
    create_table :diagnostic_tests_protein_levels do |t|
    end
    create_table :diagnostic_tests_molecule_levels do |t|
    end
    create_table :diagnostic_tests_protein_bms do |t|
    end
    create_table :diagnostic_tests_molecule_bms do |t|
    end
    create_table :diagnostic_tests_genetic_bms do |t|
    end

    remove_index "lab_tests_lab_tests", :name => "related_lab_test_index"
    add_index "diagnostic_tests_diagnostic_tests", "related_diagnostic_test_index"
    rename_table :lab_tests_lab_tests, :diagnostic_tests_diagnostic_tests
    rename_table :lab_tests, :diagnostic_tests

    rename_column :lab_test_ownerships, :lab_test_id, :diagnostic_test_id
    rename_column :lab_test_ownerships, :lab_test_owner_type, :diagnostic_test_owner_type
    rename_column :lab_test_ownerships, :lab_test_owner_id, :diagnostic_test_owner_id
    rename_table :lab_test_ownerships, :diagnostic_test_ownerships

    remove_index "bm_levels_lab_tests", :column => ["bm_level_id"]
    add_index "bm_levels_diagnostic_tests", "index_bm_levels_diagnostic_tests_on_bm_level_id"
    rename_column :bm_levels_lab_tests, :lab_test_id, :diagnostic_test_id
    rename_table :bm_levels_lab_tests, :bm_levels_diagnostic_tests

    remove_index "biofluids_lab_tests", :column => ["lab_test_id"]
    remove_index "biofluids_lab_tests", :column => ["biofluid_id"]
    add_index "biofluids_diagnostic_tests", "index_biofluids_diagnostic_tests_on_diagnostic_test_id"
    add_index "biofluids_diagnostic_tests", "index_biofluids_diagnostic_tests_on_biofluid_id"
    rename_column :biofluids_lab_tests, :lab_test_id, :diagnostic_test_id
    rename_table :biofluids_lab_tests, :biofluids_diagnostic_tests
  end
end
