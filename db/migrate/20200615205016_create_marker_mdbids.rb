class CreateMarkerMdbids < ActiveRecord::Migration
  def change
    create_table :marker_mdbids do |t|
      t.string :mdbid
      t.string :identifiable_type
      t.string :identifiable_id
      t.timestamps
    end
  end
end
