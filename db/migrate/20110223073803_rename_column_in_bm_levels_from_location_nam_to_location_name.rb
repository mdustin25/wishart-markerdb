class RenameColumnInBmLevelsFromLocationNamToLocationName < ActiveRecord::Migration
  def self.up
      rename_column :bm_levels, :location_nam, :location_name
  end

  def self.down
      rename_column :bm_levels, :location_name, :location_nam
  end
end
