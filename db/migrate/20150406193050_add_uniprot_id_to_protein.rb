class AddUniprotIdToProtein < ActiveRecord::Migration
  def change
    add_column :proteins, :uniprot_id, :string, index: true
  end
end
