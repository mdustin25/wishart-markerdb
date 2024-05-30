class AddMdbidColumnToMarkers < ActiveRecord::Migration
  def change
  	add_column :chemicals, :mdbid, :string
  	add_column :proteins, :mdbid, :string
  	add_column :genes, :mdbid, :string
  	add_column :karyotypes, :mdbid, :string
  end
end
