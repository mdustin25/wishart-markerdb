class DropIcon < ActiveRecord::Migration
  def up
    remove_index "icons", :name => "index_icons_on_id"
    drop_table "icons"
    remove_index "icon_ownerships", :name => "index_icon_ownerships_on_iconable_type"
    remove_index "icon_ownerships", :name => "index_icon_ownerships_on_iconable_id"
    drop_table "icon_ownerships"
  end

  def down
    create_table "icon_ownerships", :force => true do |t|
      t.integer "iconable_id"
      t.string  "iconable_type"
      t.integer "icon_id"
    end

    add_index "icon_ownerships", ["iconable_id"], :name => "index_icon_ownerships_on_iconable_id"
    add_index "icon_ownerships", ["iconable_type"], :name => "index_icon_ownerships_on_iconable_type"

    create_table "icons", :force => true do |t|
      t.string   "icon_image_uid"
      t.string   "icon_image_name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "icons", ["id"], :name => "index_icons_on_id"
  end
end
