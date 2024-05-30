class ChangeBiosummarizerDescriptionToTextFromGenes < ActiveRecord::Migration
  def change
  	change_column(:genes, :biosummarizer_description, :text)
  	change_column(:genes, :fasta, :text)
  	
  end
end
