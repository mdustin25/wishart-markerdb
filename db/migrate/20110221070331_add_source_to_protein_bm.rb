class AddSourceToProteinBm < ActiveRecord::Migration
  def self.up
    add_column :protein_bms, :source, :string
  end

  def self.down
    remove_column :protein_bms, :source
  end
end
