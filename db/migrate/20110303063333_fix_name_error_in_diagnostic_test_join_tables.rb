class FixNameErrorInDiagnosticTestJoinTables < ActiveRecord::Migration
  def self.up
   # make join table with references 
    # with bm_levels and with alleles
    change_table :diagnostic_tests_references do |t|
        t.rename :references_id, :reference_id
        t.rename :diagnostic_tests_id, :diagnostic_test_id
    end
    change_table :bm_levels_diagnostic_tests do |t|
        t.rename :bm_levels_id, :bm_level_id
        t.rename :diagnostic_tests_id, :diagnostic_test_id
    end
    change_table :alleles_diagnostic_tests do |t|
        t.rename :alleles_id, :allele_id
        t.rename :diagnostic_tests_id, :diagnostic_test_id
    end
    change_table :diagnostic_tests_genetic_bms do |t|
        t.rename :diagnostic_tests_id, :diagnostic_test_id
        t.rename :genetic_bms_id, :genetic_bm_id
    end
  end

  def self.down
    change_table :diagnostic_tests_references do |t|
        t.rename :reference_id, :references_id
        t.rename :diagnostic_test_id, :diagnostic_tests_id
    end
    change_table :bm_levels_diagnostic_tests do |t|
        t.rename :bm_level_id, :bm_levels_id
        t.rename :diagnostic_test_id, :diagnostic_tests_id
    end
    change_table :alleles_diagnostic_tests do |t|
        t.rename :allele_id, :alleles_id
        t.rename :diagnostic_test_id, :diagnostic_tests_id
    end
    change_table :diagnostic_tests_genetic_bms do |t|
        t.rename :diagnostic_test_id, :diagnostic_tests_id
        t.rename :genetic_bm_id, :genetic_bms_id
    end
 
  end
end
