class AddReviewDateToMoleculeBm < ActiveRecord::Migration
  def self.up
    add_column :molecule_bms, :review_date, :date
  end

  def self.down
    remove_column :molecule_bms, :review_date
  end
end
