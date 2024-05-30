class CreateBiomarkerCategoryMemberships < ActiveRecord::Migration
  def self.up
    create_table :biomarker_category_memberships do |t|
      t.references :biomarker
      t.string :biomarker_type
      t.references :biomarker_category
    end
  end

  def self.down
    drop_table :biomarker_category_memberships
  end
end
