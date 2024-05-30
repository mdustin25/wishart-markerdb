class CreateCitations < ActiveRecord::Migration
  def self.up
    create_table :citations do |t|
      t.references :citation_owner, 
        :polymorphic => true
      t.references :reference
    end
  end

  def self.down
    drop_table :citations
  end
end
