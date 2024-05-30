class ExportedKaryotypesChangeToBoolean < ActiveRecord::Migration
  def change
  	change_column :karyotypes, :exported, :boolean
  end
end
