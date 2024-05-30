class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
    	t.string   :access_token, null: false
    	t.datetime :expire_at, null: false
    	t.string   :api_type, null: false
      t.timestamps null: false
    end
    add_index :api_keys, :access_token
  end
end
