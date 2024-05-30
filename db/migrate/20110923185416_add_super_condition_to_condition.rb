class AddSuperConditionToCondition < ActiveRecord::Migration
  def self.up
    add_column :conditions, :super_condition_id, :integer
    add_column :conditions, :omim_records, :string
  end

  def self.down
    remove_column :conditions, :omim_records
    remove_column :conditions, :super_condition
  end
end
