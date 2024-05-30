class AddColumnsToExtraDescription < ActiveRecord::Migration
  def self.up
    add_column :extra_descriptions, :describable_id, :integer
    add_column :extra_descriptions, :describable_type, :string
  end

  def self.down
    remove_column :extra_descriptions, :describable_type
    remove_column :extra_descriptions, :describable_id
  end
end
