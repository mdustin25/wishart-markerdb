class AddBiosummarizerDescriptionToGenes < ActiveRecord::Migration
  def change
    add_column :genes, :biosummarizer_description, :string
  end
end
