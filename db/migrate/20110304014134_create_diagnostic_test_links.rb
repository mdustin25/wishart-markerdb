class CreateDiagnosticTestLinks < ActiveRecord::Migration
  def self.up
    create_table :diagnostic_test_links do |t|
      t.string :name
      t.references :diagnostic_test
      t.string :link

      t.timestamps
    end
  end

  def self.down
    drop_table :diagnostic_test_links
  end
end
