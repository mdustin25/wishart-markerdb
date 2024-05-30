class AddReviewDateToDiagnosticTest < ActiveRecord::Migration
  def self.up
    add_column :diagnostic_tests, :review_date, :date
  end

  def self.down
    remove_column :diagnostic_tests, :review_date
  end
end
