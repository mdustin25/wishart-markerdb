class CreateMoleculeBmAliases < ActiveRecord::Migration
  def self.up
    create_table :molecule_bm_aliases do |t|
      t.references :molecule_bm
      t.string :name
    end
  end

  def self.down
    drop_table :molecule_bm_aliases
  end
end
