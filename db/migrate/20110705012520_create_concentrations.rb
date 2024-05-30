class CreateConcentrations < ActiveRecord::Migration
  def self.up
    create_table :concentrations do |t|
      t.string :age_range
      t.string :level
      t.string :location_name
      t.text   :special_constraints
      t.string :sex
      t.string :biofluid
      t.string :comment
      t.string :range
      t.float  :high
      t.float  :low
      t.float  :mean
      t.string :units
      t.float  :pvalue

      t.timestamps
    end
  end

  def self.down
    drop_table :concentrations
  end
end
