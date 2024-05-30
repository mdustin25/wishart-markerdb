class CreateSequenceVariants < ActiveRecord::Migration
  def self.up
    create_table :sequence_variants do |t|
      t.string :description
      t.string :position
      t.string :type
      t.string :gene
      t.string :reference_sequence
      t.boolean :coding
      t.timestamps
    end
  end

  def self.down
    drop_table :sequence_variants
  end
end
