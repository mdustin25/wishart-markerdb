class CreateDiagnosticTests < ActiveRecord::Migration
  def self.up
    create_table :diagnostic_tests do |t|
      t.string :name
      t.text :description
      t.string :links

      t.timestamps
    end
    # make join table with references 
    # with bm_levels and with alleles
    create_table :references_diagnostic_tests, :id => false do |t|
        t.references :references, :diagnostic_tests
    end
    create_table :bm_levels_diagnostic_tests, :id => false do |t|
        t.references :bm_levels, :diagnostic_tests
    end
    create_table :alleles_diagnostic_tests, :id => false do |t|
        t.references :alleles, :diagnostic_tests
    end
    create_table :diagnostic_tests_genetic_bms, :id => false do |t|
        t.references :diagnostic_tests, :genetic_bms
    end
  end

  def self.down
    drop_table :diagnostic_tests
    drop_table :references_diagnostic_tests
    drop_table :bm_levels_diagnostic_tests
    drop_table :alleles_diagnostic_tests
    drop_table :diagnostic_tests_genetic_bms
  end
end
