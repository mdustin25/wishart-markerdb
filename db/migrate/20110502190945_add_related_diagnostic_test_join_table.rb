class AddRelatedDiagnosticTestJoinTable < ActiveRecord::Migration
  # table for joining related diagnostic tests
  def self.up
    create_table :diagnostic_tests_diagnostic_tests, :id => false do |t|
      t.references :diagnostic_test, :related

    end
    add_index(:diagnostic_tests_diagnostic_tests, 
      [:diagnostic_test_id,:related_id],         
      :name=>"related_diagnostic_test_index"
    )
  end

  def self.down
    remove_index(:diagnostic_tests_diagnostic_tests, :name=>"related_diagnostic_test_index")
    drop_table :diagnostic_tests_diagnostic_tests
  end
end
