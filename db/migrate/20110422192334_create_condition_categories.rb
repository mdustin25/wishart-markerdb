class CreateConditionCategories < ActiveRecord::Migration
  def self.up
    create_table :condition_categories do |t|
      t.string :name
      t.timestamps
    end
    # join table
    create_table :condition_categories_conditions, :id=>false do |t|
      t.references :condition_category, :condition
    end
  end

  def self.down
    drop_table :condition_categories_conditions
    drop_table :condition_categories
  end
end
