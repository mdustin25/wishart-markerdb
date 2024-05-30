class CreateExtraDescriptions < ActiveRecord::Migration
  def self.up
    create_table :extra_descriptions do |t|
      t.text :description
      t.string :source

      t.timestamps
    end
  end

  def self.down
    drop_table :extra_descriptions
  end
end
