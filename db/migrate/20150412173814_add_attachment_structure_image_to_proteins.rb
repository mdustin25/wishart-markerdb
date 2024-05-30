class AddAttachmentStructureImageToProteins < ActiveRecord::Migration
  def self.up
    change_table :proteins do |t|
      t.attachment :structure_image
    end
  end

  def self.down
    remove_attachment :proteins, :structure_image
  end
end
