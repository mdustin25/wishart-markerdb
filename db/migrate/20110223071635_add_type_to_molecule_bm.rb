class AddTypeToMoleculeBm < ActiveRecord::Migration
  def self.up
    add_column :molecule_bms, :type, :string
  end

  def self.down
    remove_column :molecule_bms, :type
  end
end
