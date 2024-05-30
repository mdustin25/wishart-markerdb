class CreateGeneticBms < ActiveRecord::Migration
    def self.up
        create_table :genetic_bms do |t|
            t.string :name
            t.text :description
            t.string :wikipedia_link
            t.string :kegg_link
            t.string :metagene_link
            t.string :type
            t.string :omim_link
            t.text :sequence
            t.string :position

            t.timestamps
        end
    end

    def self.down
        drop_table :genetic_bms
    end
end
