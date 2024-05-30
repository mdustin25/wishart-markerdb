class AddReviewDateToCondition < ActiveRecord::Migration
  def self.up
    add_column :conditions, :review_date, :date
  end

  def self.down
    remove_column :conditions, :review_date
  end
end
