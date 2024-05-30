class AddingKaryotypeIdToInvolvedGenes < ActiveRecord::Migration
  def change
    add_column :involved_genes, :karyotype_id, :int
    add_index :involved_genes, :karyotype_id
  end
end
