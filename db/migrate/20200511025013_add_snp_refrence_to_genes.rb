class AddSnpRefrenceToGenes < ActiveRecord::Migration
  def change
    remove_column :single_nucleotide_polymorphisms, :gene_id, :integer
    remove_column :single_nucleotide_polymorphisms, :condition_id, :integer
    add_column :single_nucleotide_polymorphisms, :gene_id, :integer, references: :genes
    add_column :single_nucleotide_polymorphisms, :condition_id, :integer, references: :conditions
       #add_reference :genes, :single_nucleotide_polymorphisms, index: true, foreign_key: true
  end
end
