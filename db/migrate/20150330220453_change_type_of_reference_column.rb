class ChangeTypeOfReferenceColumn < ActiveRecord::Migration
  def up
    change_column :references, :authors, :text
  end
  def down
    # This might cause trouble if you have strings longer
    # than 255 characters.
    change_column :references, :authors, :string
  end
end
