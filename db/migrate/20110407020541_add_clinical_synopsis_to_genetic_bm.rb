class AddClinicalSynopsisToGeneticBm < ActiveRecord::Migration
  def self.up
    add_column :genetic_bms, :clinical_synopsis, :text
  end

  def self.down
    remove_column :genetic_bms, :clinical_synopsis
  end
end
