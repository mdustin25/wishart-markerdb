class RenameTypeToVariationInSequenceVariant < ActiveRecord::Migration
  def self.up
    rename_column :sequence_variants, :type, :variation
  end

  def self.down
    rename_column :sequence_variants, :variation, :type
  end
end
