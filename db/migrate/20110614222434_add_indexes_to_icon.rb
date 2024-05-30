class AddIndexesToIcon < ActiveRecord::Migration
  def self.up
    add_index :icons, :id
    add_index :icon_ownerships, :iconable_type
    add_index :icon_ownerships, :iconable_id
  end

  def self.down
    remove_index :icon_ownerships, :column => :iconable_id
    remove_index :icon_ownerships, :column => :iconable_type
    remove_index :icons, :column => :id
  end
end
