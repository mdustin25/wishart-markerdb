class AddReviewDateToProteinBm < ActiveRecord::Migration
  def self.up
    add_column :protein_bms, :review_date, :date
  end

  def self.down
    remove_column :protein_bms, :review_date
  end
end
