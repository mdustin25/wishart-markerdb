class AddConditionAndGeneColumnsToSingleNucleotidePolymorphisms < ActiveRecord::Migration
  def change
    add_column :single_nucleotide_polymorphisms, :gene_symbol, :string
    add_column :single_nucleotide_polymorphisms, :condition_name, :string
  end
end
