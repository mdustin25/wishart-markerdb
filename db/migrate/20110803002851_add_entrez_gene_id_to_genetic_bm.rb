class AddEntrezGeneIdToGeneticBm < ActiveRecord::Migration
  def self.up
    add_column :genetic_bms, :entrez_gene_id, :integer
  end

  def self.down
    remove_column :genetic_bms, :entrez_gene_id
  end
end
