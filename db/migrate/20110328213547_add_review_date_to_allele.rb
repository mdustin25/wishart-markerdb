class AddReviewDateToAllele < ActiveRecord::Migration
  def self.up
    add_column :alleles, :review_date, :date
  end

  def self.down
    remove_column :alleles, :review_date
  end
end
