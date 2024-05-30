class AddBiofluidToMoleculeLevel < ActiveRecord::Migration
  def self.up
    add_column :molecule_levels, :biofluid, :string
  end

  def self.down
    remove_column :molecule_levels, :biofluid
  end
end
