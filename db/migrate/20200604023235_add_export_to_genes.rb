class AddExportToGenes < ActiveRecord::Migration
  def change
  	add_column :genes, :exported, :boolean
  end
end
