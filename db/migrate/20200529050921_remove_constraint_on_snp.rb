class RemoveConstraintOnSnp < ActiveRecord::Migration
  def change
    remove_index :single_nucleotide_polymorphisms, [:snp_id, :condition_id]
  end
end
