class AddingClinVarIdToSequenceVariants < ActiveRecord::Migration
  def change
    add_column :sequence_variants, :clinvar_id , :integer
  end
end
