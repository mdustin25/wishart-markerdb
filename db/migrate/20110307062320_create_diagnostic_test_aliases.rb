class CreateDiagnosticTestAliases < ActiveRecord::Migration
  def self.up
    create_table :diagnostic_test_aliases do |t|
      t.belongs_to :diagnostic_test
      t.string :name
    end
  end

  def self.down
    drop_table :diagnostic_test_aliases
  end
end
