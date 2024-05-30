class CreateConditionAliases < ActiveRecord::Migration
  def self.up
    create_table :condition_aliases do |t|
      t.references :condition
      t.string :name
    end
  end

  def self.down
    drop_table :condition_aliases
  end
end
