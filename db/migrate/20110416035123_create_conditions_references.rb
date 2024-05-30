class CreateConditionsReferences < ActiveRecord::Migration
  def self.up
      create_table :conditions_references, :id => false do |t|
        t.references :condition, :reference
      end
  end

  def self.down
      drop_table :conditions_references
  end
end
