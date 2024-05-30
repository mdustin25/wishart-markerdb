class UniprotColSequences < ActiveRecord::Migration
  def change
  	add_column :sequences, :uniprot_id, :string
  end
end
