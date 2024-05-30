class AddClinsigSeqvarmeas < ActiveRecord::Migration
  def change
  	add_column :sequence_variant_measurements, :clinical_sig, :string
  end
end
