# This migration comes from wishart (originally 20141213181332)
class CreateWishartNotices < ActiveRecord::Migration
  def change
    create_table :wishart_notices do |t|
      t.text :content, null: false
      t.boolean :display, default: false

      t.timestamps
    end
  end
end
