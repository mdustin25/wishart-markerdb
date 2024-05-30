class CreateSnps < ActiveRecord::Migration
  def self.up
    create_table :snps do |t|
      t.string :snp_id
      t.string :molecule_type

      t.timestamps
    end
  end

  def self.down
    drop_table :snps
  end
end
