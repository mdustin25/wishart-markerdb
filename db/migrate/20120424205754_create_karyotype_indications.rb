class CreateKaryotypeIndications < ActiveRecord::Migration
  def change
    create_table :karyotype_indications do |t|
      t.integer :condition_id
      t.integer :indication_type_id
      t.integer :biomarker_category_id
      t.string  :indication_modifier
      t.integer :karyotype_id

      t.timestamps
    end
  end
end
