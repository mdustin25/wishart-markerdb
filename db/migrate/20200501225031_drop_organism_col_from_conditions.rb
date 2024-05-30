class DropOrganismColFromConditions < ActiveRecord::Migration
  def change
  	remove_column :conditions, :organism
  end
end
