class AddSourceOrganismToSequenceVariants < ActiveRecord::Migration
  def change
    add_column :sequence_variants, :source, :string
    add_column :sequence_variants, :organism, :string
  end
end
