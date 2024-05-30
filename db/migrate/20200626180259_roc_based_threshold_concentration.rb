class RocBasedThresholdConcentration < ActiveRecord::Migration
  def change
  	add_column :concentrations, :related_abnormal_concentration, :text
  	add_column :roc_stats, :roc_conc_threshold, :text
  end
end
