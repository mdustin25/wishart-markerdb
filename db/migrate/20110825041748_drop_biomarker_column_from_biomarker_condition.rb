class DropBiomarkerColumnFromBiomarkerCondition < ActiveRecord::Migration
  def self.up
    remove_column :biomarker_conditions, :biomarker_type
    remove_column :biomarker_conditions, :biomarker_id
  end

  def self.down
    add_column :biomarker_conditions, :biomarker_id, :integer
    add_column :biomarker_conditions, :biomarker_type, :string
  end
end
