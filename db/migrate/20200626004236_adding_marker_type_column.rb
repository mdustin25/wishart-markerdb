class AddingMarkerTypeColumn < ActiveRecord::Migration
  def change
    add_column :sequence_variants, :marker_type, :text
  end
end
