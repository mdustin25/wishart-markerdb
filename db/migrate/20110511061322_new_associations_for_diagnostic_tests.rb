class NewAssociationsForDiagnosticTests < ActiveRecord::Migration
  def self.up
      create_table :diagnostic_tests_molecule_bms, :id => false do |t|
        t.references :diagnostic_test, :molecule_bm
      end
      create_table :diagnostic_tests_protein_bms, :id => false do |t|
        t.references :diagnostic_test, :protein_bm
      end
  end

  def self.down
      drop_table :diagnostic_tests_protein_bms
      drop_table :diagnostic_tests_molecule_bms
  end
end
