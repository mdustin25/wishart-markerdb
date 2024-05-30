class AddExportToConcentrations < ActiveRecord::Migration
  def change
  	add_column :concentrations, :exported, :boolean
  end
end
