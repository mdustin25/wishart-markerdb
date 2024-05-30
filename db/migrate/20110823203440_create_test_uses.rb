class CreateTestUses < ActiveRecord::Migration
  def self.up
    create_table :test_uses do |t|
      t.string :description
      t.references :lab_test
      t.references :condition
      t.references :biomarker_category
      t.string     :biomarker_class_name
      t.timestamps
    end
  end

  def self.down
    drop_table :test_uses
  end
end
