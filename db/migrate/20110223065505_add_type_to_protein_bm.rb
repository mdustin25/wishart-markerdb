class AddTypeToProteinBm < ActiveRecord::Migration
  def self.up
    add_column :protein_bms, :type, :string
  end

  def self.down
    remove_column :protein_bms, :type
  end
end
