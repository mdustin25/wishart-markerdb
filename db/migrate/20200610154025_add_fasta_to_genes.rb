class AddFastaToGenes < ActiveRecord::Migration
  def change
    add_column :genes, :fasta, :string
  end
end
