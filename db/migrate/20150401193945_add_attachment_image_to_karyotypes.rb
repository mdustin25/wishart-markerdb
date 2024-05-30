class AddAttachmentImageToKaryotypes < ActiveRecord::Migration
  def change
    add_attachment :karyotypes, :diagram
  end
end
