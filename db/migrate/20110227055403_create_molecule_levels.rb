class CreateMoleculeLevels < ActiveRecord::Migration
  def self.up
    create_table :molecule_levels do |t|
      t.string :comment
      t.string :age_range
      t.string :level
      t.string :location_name
      t.text :special_constraints
      t.references :condition, :null=>false
      t.references :molecule_bm, :null=>false

      t.timestamps
    end

    create_table :molecule_levels_references, :id => false do |t|
        t.references :reference, :protein_level
    end
    create_table :diagnostic_tests_molecule_levels, :id => false do |t|
        t.references :diagnostic_test, :protein_level
    end
 
  end

  def self.down
    drop_table :molecule_levels
    drop_table :molecule_levels_references
    drop_table :diagnostic_tests_molecule_levels    
  end
end
