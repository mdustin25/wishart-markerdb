class AddingReferenceToSequence < ActiveRecord::Migration
  def change
    add_column :sequence_variants, :reference, :text
    add_column :sequence_variants, :exported, :int
  end
end
