class ExtendingSeqvarChange < ActiveRecord::Migration
  def change
    remove_column :sequence_variants, :reference_sequence
    add_column :sequence_variants, :variation_sequence, :text
  end
end
