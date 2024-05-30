class AddIndexToBiomarkerCategoriesMemberships < ActiveRecord::Migration
  def up
  end
  def change
	 
#	  add_index "biomarker_category_memberships", ["mdbid"], :length => { "mdbid" => 16 }, name: "biomarker_category_mdb_id", using: :btree
#	  add_index "biomarker_category_memberships", ["biomarker_name"], :length => { "biomarker_name" => 64}, name: "biomarker_category_biomarker_name", using: :btree
#	  add_index "biomarker_category_memberships", ["biomarker_category_id", "biomarker_type", "condition_id"], name: "index_biomarker_category_memberships", using: :btree


  end
end
