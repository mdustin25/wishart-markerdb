class AddChromosomeSequenceVariant < ActiveRecord::Migration
  def change
    add_column :sequence_variants, :chromosome, :int
  end
end
