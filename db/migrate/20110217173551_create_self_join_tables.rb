class CreateSelfJoinTables < ActiveRecord::Migration
  def self.up
    # in these cases we are reference self so we have a 
    # column called similar_id which we can refer to and thus
    # keep one column with the default name
    create_table :protein_bms_protein_bms, :id => false do |t|
        t.references :protein_bm, :similar
    end
    create_table :genetic_bms_genetic_bms, :id => false do |t|
        t.references :genetic_bm, :similar
    end
    create_table :molecule_bms_molecule_bms, :id => false do |t|
        t.references :molecule_bm, :similar
    end

  end

  def self.down
    drop_table :protein_bms_protein_bms
    drop_table :genetic_bms_genetic_bms
    drop_table :molecule_bms_molecule_bms
  end
end
