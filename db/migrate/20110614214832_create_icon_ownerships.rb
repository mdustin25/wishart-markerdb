class CreateIconOwnerships < ActiveRecord::Migration
  def self.up
    create_table :icon_ownerships do |t|
      t.references :iconable
      t.string :iconable_type
      t.references :icon
    end
  end

  def self.down
    drop_table :icon_ownerships
  end
end
