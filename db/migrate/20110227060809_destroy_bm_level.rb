class DestroyBmLevel < ActiveRecord::Migration
    def self.up
        drop_table :bm_levels
    end

    def self.down

        create_table :bm_levels do |t|
            t.string :comment
            t.string :age_range
            t.string :level
            t.string :location_nam
            t.text :special_constraints
            t.references :condition, :molecule_bm, :protein_bm

            t.timestamps
        end
        create_table :bm_levels_references, :id => false do |t|
            t.references :reference, :bm_level
        end
        create_table :bm_levels_diagnostic_tests, :id => false do |t|
            t.references :bm_levels, :diagnostic_tests
        end

    end
end
