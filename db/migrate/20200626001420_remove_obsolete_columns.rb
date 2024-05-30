class RemoveObsoleteColumns < ActiveRecord::Migration
  def change
    #remove_column :sequence_variants, :clinvar_id
    remove_column :sequence_variants, :is_full_gwasrocs
    remove_column :sequence_variants, :condition_id
    add_reference :sequence_variant_measurements, :condition_id, index:true
  end
end
