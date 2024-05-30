class AddSourceToMoleculeBm < ActiveRecord::Migration
  def self.up
    add_column :molecule_bms, :source, :string
  end

  def self.down
    remove_column :molecule_bms, :source
  end
end
