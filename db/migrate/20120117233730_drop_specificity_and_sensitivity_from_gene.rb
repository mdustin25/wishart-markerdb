class DropSpecificityAndSensitivityFromGene < ActiveRecord::Migration
  def up
    rename_column :genes, :gene, :gene_symbol
    remove_column :genes, :sensitivity
    remove_column :genes, :specificity
  end

  def down
    add_column :genes, :specificity, :string
    add_column :genes, :sensitivity, :string
    rename_column :genes, :gene_symbol, :gene
  end
end
