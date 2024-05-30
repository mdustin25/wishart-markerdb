class AddStudytoSingleNucleotidePolymorphism < ActiveRecord::Migration
  def change
    remove_column :single_nucleotide_polymorphisms , :position, :float
    add_column :single_nucleotide_polymorphisms, :position, :string
    add_column :single_nucleotide_polymorphisms, :gwas_rocs_id, :string
  end
end
