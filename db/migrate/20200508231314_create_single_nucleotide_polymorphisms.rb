class CreateSingleNucleotidePolymorphisms < ActiveRecord::Migration
  def change
    create_table :single_nucleotide_polymorphisms do |t|
      t.string :snp_id
      t.integer :condition_id
      t.integer :gene_id
      t.float :auroc
      t.string :roc_curve
      t.string :logistic_equation
      t.integer :pubmed_id
      t.float :heritability
      t.float :position

      t.timestamps null: false
    end
  end
end
