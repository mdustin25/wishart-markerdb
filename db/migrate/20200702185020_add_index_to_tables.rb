class AddIndexToTables < ActiveRecord::Migration
  def change
  	add_index :sequence_variant_measurements, [:biomarker_category_id, :condition_id, :sequence_variant_id], :name => "seqvarmeas_bmcat_cond"
  	add_index :concentrations, [:exported, :solute_type, :biomarker_category_id, :solute_id], :name => "conc_solute_bmcat"
  	add_index :karyotype_indications, [:biomarker_category_id,:condition_id, :karyotype_id], :name => "karyoind_bmcat_cond"
  end
end
