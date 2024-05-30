class FixMisnamedColumn < ActiveRecord::Migration
  def self.up
    rename_column :sequence_variants, :gene, :gene_id
    rename_column :genes_genes, :gene, :gene_id
  end

  def self.down
    rename_column :genes_genes, :gene_id, :gene
    rename_column :sequence_variants, :gene_id, :gene
  end
end
