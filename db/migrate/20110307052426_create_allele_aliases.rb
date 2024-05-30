class CreateAlleleAliases < ActiveRecord::Migration
  def self.up
    create_table :allele_aliases do |t|
      t.references :allele
      t.string :name
    end
  end

  def self.down
    drop_table :allele_aliases
  end
end
