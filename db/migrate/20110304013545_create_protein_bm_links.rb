class CreateProteinBmLinks < ActiveRecord::Migration
  def self.up
    create_table :protein_bm_links do |t|
      t.string :name
      t.references :protein_bm
      t.string :link

      t.timestamps
    end
  end

  def self.down
    drop_table :protein_bm_links
  end
end
