class CreateKaryotypes < ActiveRecord::Migration
  def change
    create_table :karyotypes do |t|
      t.string :karyotype
      t.string :prognosis
      t.integer :num_cases
      t.string :gender
      t.string :frequency
      t.text :description
      t.text :ideo_description

      t.timestamps
    end
  end
end
