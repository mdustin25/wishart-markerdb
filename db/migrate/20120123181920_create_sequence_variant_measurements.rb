class CreateSequenceVariantMeasurements < ActiveRecord::Migration
  def change
    create_table :sequence_variant_measurements do |t|
      t.integer :condition_id
      t.integer :indication_type_id
      t.integer :biomarker_category_id
      t.string :indication_modifier
      t.string :comment
      t.integer :sequence_variant_id

      t.timestamps
    end
  end
end
