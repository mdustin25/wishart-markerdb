class AddingExportedToKaryotype < ActiveRecord::Migration
  def change
    add_column :karyotypes, :exported, :text
  end
end
