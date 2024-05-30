class AddGeneticBmToSequenceVariant < ActiveRecord::Migration
  def self.up
    add_column :sequence_variants, :genetic_bm_id, :integer
  end

  def self.down
    remove_column :sequence_variants, :genetic_bm_id
  end
end
