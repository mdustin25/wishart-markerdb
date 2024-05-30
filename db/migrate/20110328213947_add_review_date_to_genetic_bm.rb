class AddReviewDateToGeneticBm < ActiveRecord::Migration
  def self.up
    add_column :genetic_bms, :review_date, :date
  end

  def self.down
    remove_column :genetic_bms, :review_date
  end
end
