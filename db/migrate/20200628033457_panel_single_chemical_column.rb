class PanelSingleChemicalColumn < ActiveRecord::Migration
  def change
  	add_column :chemicals, :panel_single, :text
  	rename_column :concentrations, :related_abnormal_concentration, :reference_conc_id
  end
end
