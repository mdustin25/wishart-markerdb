class MdbidToSequenceVariant < ActiveRecord::Migration
  def change
    add_reference :sequence_variants, :mdbid, index:true
  end
end
