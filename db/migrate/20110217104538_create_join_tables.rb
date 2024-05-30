class CreateJoinTables < ActiveRecord::Migration
  def self.up
      create_table :conditions_genetic_bms, :id => false do |t|
        t.references :condition, :genetic_bm
      end
      create_table :genetic_bms_references, :id => false do |t|
        t.references :reference, :genetic_bm
      end
      create_table :molecule_bms_references, :id => false do |t|
        t.references :reference, :molecule_bm
      end
      create_table :protein_bms_references, :id => false do |t|
        t.references :reference, :protein_bm
      end
      create_table :bm_levels_references, :id => false do |t|
        t.references :reference, :bm_level
      end
      create_table :alleles_references, :id => false do |t|
        t.references :reference, :allele 
      end
  end

  def self.down
      drop_table :conditions_genetic_bms
      drop_table :genetic_bms_references
      drop_table :molecule_bms_references
      drop_table :protein_bms_references
      drop_table :bm_levels_references
      drop_table :alleles_references
  end
end
