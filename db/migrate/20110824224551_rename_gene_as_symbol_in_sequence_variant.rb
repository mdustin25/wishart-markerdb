class RenameGeneAsSymbolInSequenceVariant < ActiveRecord::Migration
  def self.up
    rename_column :sequence_variants, :gene, :gene_symbol
  end

  def self.down
    rename_column :sequence_variants, :gene_symbol, :gene
  end
end
