class ReModelBiomarkerCategoryMemberships < ActiveRecord::Migration
  def change
  	add_column :biomarker_category_memberships, :biomarker_structure, :text
  	add_column :biomarker_category_memberships, :condition_id, :integer
  	add_column :biomarker_category_memberships, :condition_name, :text
  	add_column :biomarker_category_memberships, :mdbid, :text
  	add_column :biomarker_category_memberships, :biomarker_name, :text
  	add_index :biomarker_category_memberships, [:biomarker_category_id,:biomarker_type,:condition_id], :name => "bmcat_membershiop"
  end
end
