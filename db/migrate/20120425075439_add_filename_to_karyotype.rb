class AddFilenameToKaryotype < ActiveRecord::Migration
  def change
    add_column :karyotypes, :filename, :string
  end
end
