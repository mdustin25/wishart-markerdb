class RenameProteinLevelIdToMoleculeLevelIdInMoleculeLevelsReferences < ActiveRecord::Migration
  def self.up
    rename_column :molecule_levels_references, :protein_level_id, :molecule_level_id
  end

  def self.down
    rename_column :molecule_levels_references, :molecule_level_id, :protein_level_id
  end
end
