class AddIndexesToExternalLinks < ActiveRecord::Migration
  def self.up
    add_index :external_links, :id
    add_index :external_links, :linkable_id
    add_index :external_links, :linkable_type
  end

  def self.down
    remove_index :external_links, :column => :linkable_type
    remove_index :external_links, :column => :linkable_id
    remove_index :external_links, :column => :id
  end
end
