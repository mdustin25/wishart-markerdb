class RemoveSpecificLinksFromGeneticBm < ActiveRecord::Migration
  def self.up
    change_table :genetic_bms do |t|
      t.remove :wikipedia_link
      t.remove :kegg_link
      t.remove :metagene_link
      t.remove :omim_link
    end
  end

  def self.down
    change_table :genetic_bms do |t|
      t.string :wikipedia_link
      t.string :kegg_link
      t.string :metagene_link
      t.string :omim_link
   end
  end
end
