class CreateAlleles < ActiveRecord::Migration
  def self.up
    create_table :alleles do |t|
      t.references :genetic_bm, :null => false
      t.references :condition, :null => false
      t.string :position
      t.text :description
      t.string :name
      t.string :type

      t.timestamps
    end
  end

  def self.down
    drop_table :alleles
  end
end
