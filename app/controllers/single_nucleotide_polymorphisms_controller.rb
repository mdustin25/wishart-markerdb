class SingleNucleotidePolymorphismsController < InheritedResources::Base

  private

    def single_nucleotide_polymorphism_params
      params.require(:single_nucleotide_polymorphism).permit(:name, :condition_id, :gene_id, :auroc, :roc_curve, :logistic_equation, :pubmed_id, :heritability, :position)
    end
end

