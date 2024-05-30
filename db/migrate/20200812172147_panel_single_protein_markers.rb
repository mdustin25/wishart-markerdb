class PanelSingleProteinMarkers < ActiveRecord::Migration
  def change
  	add_column :proteins, :panel_single, :text
  end
end
