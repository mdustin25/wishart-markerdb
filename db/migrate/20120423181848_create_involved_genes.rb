class CreateInvolvedGenes < ActiveRecord::Migration
  def change
    create_table :involved_genes do |t|
      t.integer :gene_id
      t.text :involvement
      t.integer :involved_with_genes_id
      t.string  :involved_with_genes_type

      t.timestamps
    end
  end
end
