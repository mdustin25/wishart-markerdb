class Drop < ActiveRecord::Migration
  def change
  	remove_column :proteins, :protein_sequence
  	remove_column :proteins, :gene_sequence
  end
end
