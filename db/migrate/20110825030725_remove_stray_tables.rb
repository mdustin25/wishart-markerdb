class RemoveStrayTables < ActiveRecord::Migration
  def self.up
    drop_table "bm_levels_lab_tests"

    drop_table "molecule_levels"
    drop_table "genetic_bms_references"

    drop_table "conditions_references"

    drop_table "bm_levels_references"

    drop_table "protein_levels_references"

    drop_table "protein_bms_references"

    drop_table "molecule_levels_references"

    drop_table "molecule_bms_references"

    drop_table "genetic_bm_aliases"

    drop_table "condition_aliases"

    drop_table "protein_bm_aliases"
    drop_table "molecule_bm_aliases"
  end

  def self.down
    create_table "molecule_bm_aliases" do |t|
      t.integer "molecule_bm_id"
      t.string  "name"
    end
    create_table "protein_bm_aliases" do |t|
      t.integer "protein_bm_id"
      t.string  "name"
    end

    create_table "condition_aliases" do |t|
      t.integer "condition_id"
      t.string  "name"
    end

    create_table "genetic_bm_aliases" do |t|
      t.integer "genetic_bm_id"
      t.string  "name"
    end

    create_table "molecule_bms_references", :id => false do |t|
      t.integer "reference_id"
      t.integer "molecule_bm_id"
    end

    create_table "molecule_levels_references", :id => false do |t|
      t.integer "reference_id"
      t.integer "molecule_level_id"
    end

    create_table "protein_bms_references", :id => false do |t|
      t.integer "reference_id"
      t.integer "protein_bm_id"
    end

    create_table "protein_levels_references", :id => false do |t|
      t.integer "reference_id"
      t.integer "protein_level_id"
    end

    create_table "bm_levels_references", :id => false do |t|
      t.integer "reference_id"
      t.integer "bm_level_id"
    end

    create_table "conditions_references", :id => false do |t|
      t.integer "condition_id"
      t.integer "reference_id"
    end

    create_table "genetic_bms_references", :id => false do |t|
      t.integer "genetic_bm_id"
      t.integer "reference_id"
    end
    create_table "molecule_levels" do |t|
      t.string   "comment"
      t.string   "age_range"
      t.string   "level"
      t.string   "location_name"
      t.text     "special_constraints"
      t.integer  "condition_id",        :null => false
      t.integer  "molecule_bm_id",      :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "specificity"
      t.string   "sensitivity"
      t.string   "sex"
      t.string   "biofluid"
      t.float    "mean"
      t.string   "range"
      t.float    "high"
      t.float    "low"
      t.string   "units"
    end

    create_table "bm_levels_lab_tests", :id => false, :force => true do |t|
      t.integer "bm_level_id"
      t.integer "lab_test_id"
    end

  end
end
