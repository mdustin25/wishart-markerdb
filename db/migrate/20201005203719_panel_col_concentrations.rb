class PanelColConcentrations < ActiveRecord::Migration
  def change
  	add_column :concentrations, :logistic_equation, :text
  	add_column :chemicals, :panel_marker_id, :text
  end
end
