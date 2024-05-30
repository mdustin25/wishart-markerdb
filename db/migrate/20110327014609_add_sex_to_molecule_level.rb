class AddSexToMoleculeLevel < ActiveRecord::Migration
  def self.up
    add_column :molecule_levels, :sex, :string
  end

  def self.down
    remove_column :molecule_levels, :sex
  end
end
