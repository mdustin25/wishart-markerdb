class DropBiomarkerConditions < ActiveRecord::Migration
  def self.up
    drop_table :biomarker_conditions
  end

  def self.down
    create_table "biomarker_conditions" do |t|
      t.integer "condition_id"
      t.integer "measurement_id"
      t.string  "measurement_type"
      t.string  "indication_modifier"
      t.integer "indication_type_id"
      t.string  "comment"
    end
  end
end
