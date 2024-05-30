class DropAdminUsers < ActiveRecord::Migration
  def up
    drop_table "admin_users"
  end

  def down
    create_table "admin_users", :force => true do |t|
      t.string   "first_name",       :default => "",    :null => false
      t.string   "last_name",        :default => "",    :null => false
      t.string   "role",                                :null => false
      t.string   "email",                               :null => false
      t.boolean  "status",           :default => false
      t.string   "token",                               :null => false
      t.string   "salt",                                :null => false
      t.string   "crypted_password",                    :null => false
      t.string   "preferences"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
