class InvolvedGene < ActiveRecord::Base
  belongs_to :involved_with_genes, :polymorphic => true
  belongs_to :gene

  # delegate all the gene methods to gene so that
  # this behaves just like a gene
  delegate :to_param, :name, :description, :genetic_type, 
    :sequence, :position, :dominance, :source_common,
    :clinical_synopsis, :omim_type, :omim_id, 
    :gene_symbol, :source_taxname, :entrez_gene_id, 
    :to => :gene

end


# == Schema Information
#
# Table name: involved_genes
#
#  id                       :integer(4)      not null, primary key
#  gene_id                  :integer(4)
#  involvement              :text
#  involved_with_genes_id   :integer(4)
#  involved_with_genes_type :string(255)
#  created_at               :datetime        not null
#  updated_at               :datetime        not null
#

