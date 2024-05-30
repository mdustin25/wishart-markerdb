class AddSourceColToBiomarkers < ActiveRecord::Migration
  def change
  	add_column :chemicals, :info_source, :text
  	add_column :proteins, :info_source, :text
  	add_column :karyotypes, :info_source, :text
  	add_column :genes, :info_source, :text
  	add_column :conditions, :info_source, :text
  end
end
