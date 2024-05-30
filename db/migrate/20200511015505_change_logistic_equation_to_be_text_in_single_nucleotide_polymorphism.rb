class ChangeLogisticEquationToBeTextInSingleNucleotidePolymorphism < ActiveRecord::Migration
  def change
    change_column :single_nucleotide_polymorphisms, :logistic_equation, :text
  end
end
