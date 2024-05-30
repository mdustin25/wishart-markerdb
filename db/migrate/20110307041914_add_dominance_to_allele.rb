class AddDominanceToAllele < ActiveRecord::Migration
  def self.up
    add_column :alleles, :dominance, :string
  end

  def self.down
    remove_column :alleles, :dominance
  end
end
