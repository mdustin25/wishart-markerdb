class CreateGeneticBmAliases < ActiveRecord::Migration
  def self.up
    create_table :genetic_bm_aliases do |t|
      t.references :genetic_bm
      t.string :name
    end
  end

  def self.down
    drop_table :genetic_bm_aliases
  end
end
