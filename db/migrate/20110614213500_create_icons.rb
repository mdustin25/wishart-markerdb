class CreateIcons < ActiveRecord::Migration
  def self.up
    create_table :icons do |t|
      t.string :icon_image_uid
      t.string :icon_image_name

      t.timestamps
    end
  end

  def self.down
    drop_table :icons
  end
end
