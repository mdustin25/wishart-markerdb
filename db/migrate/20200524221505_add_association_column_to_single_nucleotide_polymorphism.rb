class AddAssociationColumnToSingleNucleotidePolymorphism < ActiveRecord::Migration
  def change
    add_column :single_nucleotide_polymorphisms, :status, :string
  end
end
