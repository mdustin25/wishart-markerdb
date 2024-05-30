class AddExportedToChemicals < ActiveRecord::Migration
  def change
  	add_column :chemicals, :exported, :boolean
  end
end
