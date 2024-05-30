class DropMarkerConditions < ActiveRecord::Migration
  def self.up
    drop_table :marker_conditions
  end

  def self.down
    create_table "marker_conditions" do |t|
      t.integer "marker_id"
      t.integer "condition_id"
      t.integer "measurement_id"
      t.string  "measurement_type"
      t.integer "result_id"
      t.string  "result_type"
    end
  end
end
