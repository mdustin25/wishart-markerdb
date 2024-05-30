class CreateFdaKits < ActiveRecord::Migration
  def self.up
    create_table :fda_kits do |t|
      t.string    :doc_number
      t.string    :company
      t.string    :name
      t.date      :approved_date
      t.references :diagnostic_test
    end
  end

  def self.down
    drop_table :fda_kits
  end
end
