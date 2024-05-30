class AddExportedToConditions < ActiveRecord::Migration
  def change
  	add_column :conditions, :exported, :boolean
  end
end
