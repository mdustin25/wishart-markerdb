class RenameTableReferencesDiagnosticTestsToDiagnosticTestsReferences < ActiveRecord::Migration
  def self.up
      rename_table :references_diagnostic_tests, :diagnostic_tests_references
  end

  def self.down
      rename_table :diagnostic_tests_references,:references_diagnostic_tests
  end
end
