class ChangeChemicalsMoldbDataType < ActiveRecord::Migration
  def change
  	change_column :chemicals, :moldb_mono_mass, :decimal, precision: 14, scale: 9
  	change_column :chemicals, :moldb_average_mass, :decimal, precision: 9, scale: 4
  end
end
