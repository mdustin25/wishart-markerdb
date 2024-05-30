class AddSoluteToConcentration < ActiveRecord::Migration
  def self.up
    add_column :concentrations, :solute_type, :string
    add_column :concentrations, :solute_id, :integer
  end

  def self.down
    remove_column :concentrations, :solute_id
    remove_column :concentrations, :solute_type
  end
end
