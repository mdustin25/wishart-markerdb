class CreateProteinBmAliases < ActiveRecord::Migration
  def self.up
    create_table :protein_bm_aliases do |t|
      t.references :protein_bm
      t.string :name
    end
  end

  def self.down
    drop_table :protein_bm_aliases
  end
end
