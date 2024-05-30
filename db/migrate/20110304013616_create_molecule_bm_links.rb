class CreateMoleculeBmLinks < ActiveRecord::Migration
  def self.up
    create_table :molecule_bm_links do |t|
      t.string :name
      t.references :molecule_bm
      t.string :link

      t.timestamps
    end
  end

  def self.down
    drop_table :molecule_bm_links
  end
end
