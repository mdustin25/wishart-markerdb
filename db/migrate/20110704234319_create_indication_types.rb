class CreateIndicationTypes < ActiveRecord::Migration
  def self.up
    create_table :indication_types do |t|
      t.references :biomarker_category
      t.string :indication
      t.timestamps
    end
  end

  def self.down
    drop_table :indication_types
  end
end
