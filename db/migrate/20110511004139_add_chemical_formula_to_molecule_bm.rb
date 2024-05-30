class AddChemicalFormulaToMoleculeBm < ActiveRecord::Migration
  def self.up
    add_column :molecule_bms, :chemical_formula, :string
  end

  def self.down
    remove_column :molecule_bms, :chemical_formula
  end
end
