class SpecialConstrationsSeqVarMeas < ActiveRecord::Migration
  def change
  	add_column :sequence_variant_measurements, :special_constraints, :text
  end
end
