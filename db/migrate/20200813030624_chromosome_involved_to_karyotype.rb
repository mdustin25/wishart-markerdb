class ChromosomeInvolvedToKaryotype < ActiveRecord::Migration
  def change
  	add_column :karyotypes, :chromosome_involved, :text
  end
end
