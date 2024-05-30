class AddFractionAloneToKaryotype < ActiveRecord::Migration
  def change
    add_column :karyotypes, :fraction_alone, :string
    add_column :karyotypes, :median_age, :string
  end
end
