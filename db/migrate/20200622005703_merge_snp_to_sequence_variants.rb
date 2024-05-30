class MergeSnpToSequenceVariants < ActiveRecord::Migration
  def change
    add_column :sequence_variants, :external_id, :int

    add_column :sequence_variants, :external_type, :text
    add_column :sequence_variant_measurements, :logistic_equation, :text
    add_column :sequence_variant_measurements, :roc_curve, :text
    add_column :sequence_variant_measurements, :pubmed_id, :int
    remove_column :sequence_variants , :clinvar_id
    add_column :sequence_variant_measurements, :auroc, :float
    add_column :sequence_variant_measurements, :heritability, :float
    add_column :sequence_variants, :is_full_gwasrocs, :boolean
    
    
  end
end
