class AddExportedToProtein < ActiveRecord::Migration
  def change
  	add_column :proteins, :exported, :boolean
  end
end
