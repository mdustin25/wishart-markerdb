class AddImagPdbidToProteins < ActiveRecord::Migration
  def change
    add_column :proteins, :structure_image_pdb_id, :string
  end
end
