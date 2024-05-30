class CreatePanelMeasurements < ActiveRecord::Migration
  def change
    create_table :panel_measurements do |t|
      t.references :panel, index: true
      t.references :measurement, index: true

      t.timestamps
    end
  end
end
