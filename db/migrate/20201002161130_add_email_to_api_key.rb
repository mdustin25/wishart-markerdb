class AddEmailToApiKey < ActiveRecord::Migration
  def change
  	add_column :api_keys, :email, :string
  end
end
