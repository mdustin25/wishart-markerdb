class CreateBiomarkerConsumptions < ActiveRecord::Migration
  def change
    create_table :chemical_consumptions, :id => false do |t|
      t.integer :chemical_id
      t.integer :consumption_id
      t.timestamps null: false
    end
  end
end
