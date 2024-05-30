class AddUniqueKeyToCitation < ActiveRecord::Migration
  def self.up
    execute <<-SQL
    alter table citations
      add unique key `citation_key` 
      (`citation_owner_id`, `citation_owner_type`, `reference_id`)
    SQL
  end

  def self.down
  end
end
