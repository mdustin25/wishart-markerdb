class AddPumedIdAndReviewDateToReference < ActiveRecord::Migration
  def self.up
    add_column :references, :pubmed_id, :integer
    add_column :references, :review_date, :date
  end

  def self.down
    remove_column :references, :review_date
    remove_column :references, :pubmed_id
  end
end
