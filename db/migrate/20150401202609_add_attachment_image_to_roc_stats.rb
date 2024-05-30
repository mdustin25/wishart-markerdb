class AddAttachmentImageToRocStats < ActiveRecord::Migration
  def change
    add_attachment :roc_stats, :image
  end
end
