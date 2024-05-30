class AddIupacToMoleculeBm < ActiveRecord::Migration
  def self.up
    add_column :molecule_bms, :iupac, :string
  end

  def self.down
    remove_column :molecule_bms, :iupac
  end
end
