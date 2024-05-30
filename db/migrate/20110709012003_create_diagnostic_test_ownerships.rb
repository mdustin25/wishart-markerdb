class CreateDiagnosticTestOwnerships < ActiveRecord::Migration
  def self.up
    create_table :diagnostic_test_ownerships do |t|
      t.references :diagnostic_test_owner, :polymorphic => true
      t.references :diagnostic_test
    end
  end

  def self.down
    drop_table :diagnostic_test_ownerships
  end
end
