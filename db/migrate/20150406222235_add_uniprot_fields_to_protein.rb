class AddUniprotFieldsToProtein < ActiveRecord::Migration
  def change
    add_column :proteins, :general_function, :text
    add_column :proteins, :uniprot_name, :string
    add_column :proteins, :genecard_id, :string
    add_column :proteins, :hgnc_id, :string
  end
end
