class AddConstraintToSingleNucleotidePolymorphism < ActiveRecord::Migration
  def change
    add_index :single_nucleotide_polymorphisms, [:snp_id, :condition_id], :unique => true
  end
end
