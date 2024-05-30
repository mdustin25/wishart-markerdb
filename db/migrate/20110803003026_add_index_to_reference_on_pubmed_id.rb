class AddIndexToReferenceOnPubmedId < ActiveRecord::Migration
  def self.up
    add_index :references, :pubmed_id
  end

  def self.down
    remove_index :references, :column => :pubmed_id
  end
end
