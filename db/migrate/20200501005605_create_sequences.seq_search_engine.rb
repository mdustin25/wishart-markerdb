# This migration comes from seq_search_engine (originally 20130919220023)
class CreateSequences < ActiveRecord::Migration
  def change
    create_table :sequences do |t|
      t.string :type, null: false
      t.references :sequenceable, 
        polymorphic: true, 
        index: { name: 'index_on_polymorphic' },
        null: false
      t.string :header, null: false, limit: 1000
      t.text :chain, null: false
      
      t.timestamps
    end
  end
end
