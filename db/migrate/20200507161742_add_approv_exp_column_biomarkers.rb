class AddApprovExpColumnBiomarkers < ActiveRecord::Migration
  def change
  	add_column :concentrations,:status,:string
  	add_column :karyotypes,:status,:string
  	add_column :sequence_variant_measurements,:status,:string
  end
end
