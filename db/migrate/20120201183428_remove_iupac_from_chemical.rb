class RemoveIupacFromChemical < ActiveRecord::Migration
  def up
    remove_column :chemicals, :chemical_formula
    remove_column :chemicals, :iupac
    remove_column :chemicals, :mol_file
    remove_column :chemicals, :sdf_file
    remove_column :chemicals, :pdb_file
  end

  def down
    add_column :chemicals, :pdb_file, :text
    add_column :chemicals, :sdf_file, :text    
    add_column :chemicals, :mol_file, :text
    add_column :chemicals, :iupac, :string
    add_column :chemicals, :chemical_formula, :string
  end
end
