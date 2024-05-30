class AddColumnToGeneticBm < ActiveRecord::Migration
  def self.up
    add_column :genetic_bms, :source_taxname, :string
    rename_column :genetic_bms, :source, :source_common
  end

  def self.down
    rename_column :genetic_bms, :source_common, :source
    remove_column :genetic_bms, :source_taxname
  end
end
