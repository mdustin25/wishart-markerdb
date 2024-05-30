class RenameStatusColumnSeqvarmeas < ActiveRecord::Migration
  def change
  	rename_column :sequence_variant_measurements, :status, :approved
  end
end
