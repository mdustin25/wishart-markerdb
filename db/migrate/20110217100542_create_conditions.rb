class CreateConditions < ActiveRecord::Migration
  def self.up
    create_table :conditions do |t|
      t.string :name
      t.text :description
      t.string :links
      t.string :organism

      t.timestamps
    end
  end

  def self.down
    drop_table :conditions
  end
end
