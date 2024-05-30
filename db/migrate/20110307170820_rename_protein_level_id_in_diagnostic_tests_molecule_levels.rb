class RenameProteinLevelIdInDiagnosticTestsMoleculeLevels < ActiveRecord::Migration
  def self.up
    rename_column :diagnostic_tests_molecule_levels, :protein_level_id, :molecule_level_id
  end

  def self.down
    rename_column :diagnostic_tests_molecule_levels, :molecule_level_id, :protein_level_id
  end
end
