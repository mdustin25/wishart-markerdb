class AddParentChildRelationToSequenceVariant < ActiveRecord::Migration
  def change
    add_column :sequence_variants, :parent_id, :int
  end
end
