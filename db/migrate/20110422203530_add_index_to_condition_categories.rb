class AddIndexToConditionCategories < ActiveRecord::Migration
  def self.up
    # have to name the index, otherwise name is too long
    add_index(:condition_categories_conditions, 
              [:condition_category_id,:condition_id], 
              :name=>"condition_categories_index")
  end

  def self.down
    remove_index(:condition_categories_conditions,:name=>"condition_categories_index")
  end
end
