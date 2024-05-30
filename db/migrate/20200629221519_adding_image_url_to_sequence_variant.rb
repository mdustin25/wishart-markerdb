class AddingImageUrlToSequenceVariant < ActiveRecord::Migration
  def change
    add_column :sequence_variants, :image_url, :text
    add_column :sequence_variants, :image_id, :text
  end
end
