class CreateExternalLinks < ActiveRecord::Migration
  def self.up
    create_table :external_links do |t|
      t.references :linkable, :polymorphic => true
      t.string :name
      t.string :key
      t.string :url
      t.references :link_type
    end
  end

  def self.down
    drop_table :external_links
  end
end
