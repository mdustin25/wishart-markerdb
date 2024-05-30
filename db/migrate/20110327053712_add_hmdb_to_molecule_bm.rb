class AddHmdbToMoleculeBm < ActiveRecord::Migration
  def self.up
    add_column :molecule_bms, :hmdb, :string
  end

  def self.down
    remove_column :molecule_bms, :hmdb
  end
end
