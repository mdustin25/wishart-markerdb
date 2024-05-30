class CreateGeneticBmLinks < ActiveRecord::Migration
  def self.up
    create_table :genetic_bm_links do |t|
      t.string :name
      t.references :genetic_bm
      t.string :link

      t.timestamps
    end
  end

  def self.down
    drop_table :genetic_bm_links
  end
end
