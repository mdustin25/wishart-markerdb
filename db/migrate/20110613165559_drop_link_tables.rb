class DropLinkTables < ActiveRecord::Migration
  def self.up
    drop_table :diagnostic_test_links
    drop_table :protein_bm_links
    drop_table :molecule_bm_links
    drop_table :genetic_bm_links
    drop_table :condition_links
  end

  def self.down
    # okay so this is not a perfect reverse migration
    # but we have deleted these models and moved
    # the data
    create_table :condition_links do |t|
    end
    create_table :genetic_bm_links do |t|
    end
    create_table :molecule_bm_links do |t|
    end
    create_table :protein_bm_links do |t|
    end
    create_table :diagnostic_test_links do |t|
    end
  end
end
