# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20201013165740) do

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace",     limit: 255
    t.text     "body",          limit: 65535
    t.string   "resource_id",   limit: 255,   null: false
    t.string   "resource_type", limit: 255,   null: false
    t.integer  "author_id",     limit: 4
    t.string   "author_type",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "aliases", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.integer  "aliasable_id",   limit: 4
    t.string   "aliasable_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "alleles", force: :cascade do |t|
    t.integer  "genetic_bm_id", limit: 4,     null: false
    t.integer  "condition_id",  limit: 4,     null: false
    t.string   "position",      limit: 255
    t.text     "description",   limit: 65535
    t.string   "name",          limit: 255
    t.string   "type",          limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "alleles_diagnostic_tests", id: false, force: :cascade do |t|
    t.integer "alleles_id",          limit: 4
    t.integer "diagnostic_tests_id", limit: 4
  end

  create_table "alleles_references", id: false, force: :cascade do |t|
    t.integer "reference_id", limit: 4
    t.integer "allele_id",    limit: 4
  end

  create_table "api_keys", force: :cascade do |t|
    t.string   "access_token", limit: 255, null: false
    t.datetime "expire_at",                null: false
    t.string   "api_type",     limit: 255, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "email",        limit: 255
  end

  add_index "api_keys", ["access_token"], name: "index_api_keys_on_access_token", using: :btree

  create_table "biofluids", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "biofluids_lab_tests", id: false, force: :cascade do |t|
    t.integer "biofluid_id", limit: 4
    t.integer "lab_test_id", limit: 4
  end

  add_index "biofluids_lab_tests", ["biofluid_id"], name: "index_biofluids_lab_tests_on_biofluid_id", using: :btree
  add_index "biofluids_lab_tests", ["lab_test_id"], name: "index_biofluids_lab_tests_on_lab_test_id", using: :btree

  create_table "biomarker_categories", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "biomarker_category_memberships", force: :cascade do |t|
    t.integer "biomarker_id",          limit: 4
    t.string  "biomarker_type",        limit: 255
    t.integer "biomarker_category_id", limit: 4
    t.text    "biomarker_structure",   limit: 65535
    t.integer "condition_id",          limit: 4
    t.text    "condition_name",        limit: 65535
    t.text    "mdbid",                 limit: 255
    t.text    "biomarker_name",        limit: 255
  end

  add_index "biomarker_category_memberships", ["biomarker_category_id", "biomarker_type", "condition_id"], name: "index_biomarker_category_memberships", using: :btree
  add_index "biomarker_category_memberships", ["biomarker_name"], name: "biomarker_category_biomarker_name", length: {"biomarker_name"=>64}, using: :btree
  add_index "biomarker_category_memberships", ["mdbid"], name: "biomarker_category_mdb_id", length: {"mdbid"=>16}, using: :btree

  create_table "bm_levels_diagnostic_tests", id: false, force: :cascade do |t|
    t.integer "bm_levels_id",        limit: 4
    t.integer "diagnostic_tests_id", limit: 4
  end

  create_table "bm_levels_references", id: false, force: :cascade do |t|
    t.integer "reference_id", limit: 4
    t.integer "bm_level_id",  limit: 4
  end

  create_table "chemical_consumptions", id: false, force: :cascade do |t|
    t.integer  "chemical_id",    limit: 4
    t.integer  "consumption_id", limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "chemicals", force: :cascade do |t|
    t.string   "name",                       limit: 255
    t.text     "description",                limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "source",                     limit: 255
    t.string   "molecule_type",              limit: 255
    t.string   "hmdb",                       limit: 255
    t.date     "review_date"
    t.text     "moldb_smiles",               limit: 65535
    t.string   "moldb_formula",              limit: 255
    t.text     "moldb_inchi",                limit: 65535
    t.string   "moldb_inchikey",             limit: 255
    t.text     "moldb_iupac",                limit: 65535
    t.string   "moldb_logp",                 limit: 255
    t.string   "moldb_pka",                  limit: 255
    t.decimal  "moldb_average_mass",                       precision: 9,  scale: 4
    t.decimal  "moldb_mono_mass",                          precision: 14, scale: 9
    t.string   "moldb_alogps_solubility",    limit: 255
    t.string   "moldb_alogps_logp",          limit: 255
    t.string   "moldb_alogps_logs",          limit: 255
    t.string   "moldb_acceptor_count",       limit: 255
    t.string   "moldb_donor_count",          limit: 255
    t.string   "moldb_rotatable_bond_count", limit: 255
    t.string   "moldb_polar_surface_area",   limit: 255
    t.string   "moldb_refractivity",         limit: 255
    t.string   "moldb_polarizability",       limit: 255
    t.text     "moldb_traditional_iupac",    limit: 65535
    t.integer  "moldb_formal_charge",        limit: 4
    t.integer  "moldb_physiological_charge", limit: 4
    t.string   "moldb_pka_strongest_basic",  limit: 255
    t.string   "moldb_pka_strongest_acidic", limit: 255
    t.string   "moldb_bioavailability",      limit: 255
    t.integer  "moldb_number_of_rings",      limit: 4
    t.boolean  "moldb_rule_of_five"
    t.boolean  "moldb_ghose_filter"
    t.boolean  "moldb_veber_rule"
    t.boolean  "moldb_mddr_like_rule"
    t.boolean  "exported"
    t.string   "mdbid",                      limit: 255
    t.text     "panel_single",               limit: 65535
    t.text     "info_source",                limit: 65535
    t.text     "panel_marker_id",            limit: 65535
  end

  add_index "chemicals", ["id"], name: "index_chemicals_on_id", using: :btree

  create_table "chemicals_chemicals", id: false, force: :cascade do |t|
    t.integer "chemical_id", limit: 4
    t.integer "similar_id",  limit: 4
  end

  create_table "citations", force: :cascade do |t|
    t.integer "citation_owner_id",   limit: 4
    t.string  "citation_owner_type", limit: 255
    t.integer "reference_id",        limit: 4
  end

  add_index "citations", ["citation_owner_id", "citation_owner_type", "reference_id"], name: "citation_key", unique: true, using: :btree

  create_table "concentrations", force: :cascade do |t|
    t.string   "age_range",             limit: 255
    t.string   "level",                 limit: 255
    t.string   "location_name",         limit: 255
    t.text     "special_constraints",   limit: 65535
    t.string   "sex",                   limit: 255
    t.string   "biofluid",              limit: 255
    t.string   "comment",               limit: 255
    t.string   "range",                 limit: 255
    t.float    "high",                  limit: 24
    t.float    "low",                   limit: 24
    t.float    "mean",                  limit: 24
    t.string   "units",                 limit: 255
    t.float    "pvalue",                limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "solute_type",           limit: 255
    t.integer  "solute_id",             limit: 4
    t.integer  "condition_id",          limit: 4
    t.integer  "indication_type_id",    limit: 4
    t.integer  "biomarker_category_id", limit: 4
    t.string   "indication_modifier",   limit: 255
    t.integer  "quality_id",            limit: 4
    t.string   "quality_type",          limit: 255
    t.string   "status",                limit: 255
    t.boolean  "exported"
    t.text     "reference_conc_id",     limit: 65535
    t.text     "logistic_equation",     limit: 65535
  end

  add_index "concentrations", ["exported", "solute_type", "biomarker_category_id", "solute_id"], name: "conc_solute_bmcat", using: :btree
  add_index "concentrations", ["quality_id", "quality_type"], name: "index_concentrations_on_quality_id_and_quality_type", using: :btree

  create_table "condition_categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "condition_categories_conditions", id: false, force: :cascade do |t|
    t.integer "condition_category_id", limit: 4
    t.integer "condition_id",          limit: 4
  end

  add_index "condition_categories_conditions", ["condition_category_id", "condition_id"], name: "condition_categories_index", using: :btree

  create_table "conditions", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.text     "description",        limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "delta",                            default: true, null: false
    t.date     "review_date"
    t.integer  "super_condition_id", limit: 4
    t.string   "omim_records",       limit: 255
    t.boolean  "exported"
    t.text     "info_source",        limit: 65535
  end

  add_index "conditions", ["id"], name: "index_conditions_on_id", using: :btree
  add_index "conditions", ["name"], name: "index_conditions_on_name", using: :btree

  create_table "conditions_genetic_bms", id: false, force: :cascade do |t|
    t.integer "condition_id",  limit: 4
    t.integer "genetic_bm_id", limit: 4
  end

  create_table "consumptions", force: :cascade do |t|
    t.string   "intake",           limit: 255
    t.string   "intake_level",     limit: 255
    t.string   "biofluid",         limit: 255
    t.string   "biomarker",        limit: 255
    t.string   "biomarker_level",  limit: 255
    t.float    "correlation",      limit: 24
    t.string   "p_value",          limit: 255
    t.string   "correlation_type", limit: 255
    t.string   "population",       limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "intake_unit",      limit: 255
    t.string   "biomarker_unit",   limit: 255
  end

  create_table "diagnostic_tests", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.string   "links",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "approval",    limit: 255
  end

  create_table "diagnostic_tests_genetic_bms", id: false, force: :cascade do |t|
    t.integer "diagnostic_tests_id", limit: 4
    t.integer "genetic_bms_id",      limit: 4
  end

  create_table "diagnostic_tests_references", id: false, force: :cascade do |t|
    t.integer "references_id",       limit: 4
    t.integer "diagnostic_tests_id", limit: 4
  end

  create_table "external_links", force: :cascade do |t|
    t.integer "linkable_id",   limit: 4
    t.string  "linkable_type", limit: 255
    t.string  "name",          limit: 255
    t.string  "key",           limit: 255
    t.string  "url",           limit: 255
    t.integer "link_type_id",  limit: 4
  end

  add_index "external_links", ["id"], name: "index_external_links_on_id", using: :btree
  add_index "external_links", ["linkable_id"], name: "index_external_links_on_linkable_id", using: :btree
  add_index "external_links", ["linkable_type"], name: "index_external_links_on_linkable_type", using: :btree

  create_table "extra_descriptions", force: :cascade do |t|
    t.text     "description",      limit: 65535
    t.string   "source",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "describable_id",   limit: 4
    t.string   "describable_type", limit: 255
  end

  create_table "fda_kits", force: :cascade do |t|
    t.string  "doc_number",    limit: 255
    t.string  "company",       limit: 255
    t.string  "name",          limit: 255
    t.date    "approved_date"
    t.integer "lab_test_id",   limit: 4
  end

  create_table "fda_reports", force: :cascade do |t|
    t.string "doc_number",    limit: 255
    t.string "company",       limit: 255
    t.string "device_name",   limit: 255
    t.date   "date_approved"
  end

  create_table "genes", force: :cascade do |t|
    t.string   "name",                      limit: 255
    t.text     "description",               limit: 65535
    t.string   "genetic_type",              limit: 255
    t.text     "sequence",                  limit: 65535
    t.string   "position",                  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "dominance",                 limit: 255
    t.string   "source_common",             limit: 255
    t.date     "review_date"
    t.text     "clinical_synopsis",         limit: 65535
    t.string   "omim_type",                 limit: 255
    t.integer  "omim_id",                   limit: 4
    t.string   "gene_symbol",               limit: 255
    t.string   "source_taxname",            limit: 255
    t.integer  "entrez_gene_id",            limit: 4
    t.boolean  "exported"
    t.text     "biosummarizer_description", limit: 65535
    t.text     "fasta",                     limit: 65535
    t.string   "mdbid",                     limit: 255
    t.text     "info_source",               limit: 65535
  end

  add_index "genes", ["id"], name: "index_genes_on_id", using: :btree
  add_index "genes", ["omim_id"], name: "index_genes_on_omim_id", using: :btree

  create_table "genes_genes", id: false, force: :cascade do |t|
    t.integer "gene_id",    limit: 4
    t.integer "similar_id", limit: 4
  end

  create_table "genetic_bms", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.text     "description",    limit: 65535
    t.string   "wikipedia_link", limit: 255
    t.string   "kegg_link",      limit: 255
    t.string   "metagene_link",  limit: 255
    t.string   "type",           limit: 255
    t.string   "omim_link",      limit: 255
    t.text     "sequence",       limit: 65535
    t.string   "position",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "dominance",      limit: 255
    t.string   "source",         limit: 255
  end

  create_table "genetic_bms_genetic_bms", id: false, force: :cascade do |t|
    t.integer "genetic_bm_id", limit: 4
    t.integer "similar_id",    limit: 4
  end

  create_table "genetic_bms_references", id: false, force: :cascade do |t|
    t.integer "reference_id",  limit: 4
    t.integer "genetic_bm_id", limit: 4
  end

  create_table "indication_types", force: :cascade do |t|
    t.integer  "biomarker_category_id", limit: 4
    t.string   "indication",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "involved_genes", force: :cascade do |t|
    t.integer  "gene_id",                  limit: 4
    t.text     "involvement",              limit: 65535
    t.integer  "involved_with_genes_id",   limit: 4
    t.string   "involved_with_genes_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "karyotype_id",             limit: 4
  end

  add_index "involved_genes", ["karyotype_id"], name: "index_involved_genes_on_karyotype_id", using: :btree

  create_table "karyotype_indications", force: :cascade do |t|
    t.integer  "condition_id",          limit: 4
    t.integer  "indication_type_id",    limit: 4
    t.integer  "biomarker_category_id", limit: 4
    t.string   "indication_modifier",   limit: 255
    t.integer  "karyotype_id",          limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quality_id",            limit: 4
    t.string   "quality_type",          limit: 255
    t.text     "gene_list",             limit: 65535
    t.text     "age",                   limit: 65535
    t.text     "sex",                   limit: 65535
    t.text     "citation",              limit: 65535
    t.text     "exported",              limit: 65535
  end

  add_index "karyotype_indications", ["biomarker_category_id", "condition_id", "karyotype_id"], name: "karyoind_bmcat_cond", using: :btree
  add_index "karyotype_indications", ["quality_id", "quality_type"], name: "index_karyotype_indications_on_quality_id_and_quality_type", using: :btree

  create_table "karyotypes", force: :cascade do |t|
    t.string   "karyotype",            limit: 255
    t.string   "prognosis",            limit: 255
    t.integer  "num_cases",            limit: 4
    t.string   "gender",               limit: 255
    t.string   "frequency",            limit: 255
    t.text     "description",          limit: 65535
    t.text     "ideo_description",     limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "fraction_alone",       limit: 255
    t.string   "median_age",           limit: 255
    t.string   "filename",             limit: 255
    t.string   "diagram_file_name",    limit: 255
    t.string   "diagram_content_type", limit: 255
    t.integer  "diagram_file_size",    limit: 4
    t.datetime "diagram_updated_at"
    t.string   "status",               limit: 255
    t.string   "mdbid",                limit: 255
    t.boolean  "exported"
    t.text     "chromosome_involved",  limit: 65535
    t.text     "info_source",          limit: 65535
  end

  create_table "lab_test_ownerships", force: :cascade do |t|
    t.integer "lab_test_owner_id",   limit: 4
    t.string  "lab_test_owner_type", limit: 255
    t.integer "lab_test_id",         limit: 4
  end

  create_table "lab_tests", force: :cascade do |t|
    t.string   "name",                 limit: 255
    t.text     "description",          limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "review_date"
    t.string   "fda_search_term",      limit: 255
    t.string   "formal_name",          limit: 255
    t.string   "lab_test_online_name", limit: 255
  end

  create_table "lab_tests_lab_tests", id: false, force: :cascade do |t|
    t.integer "lab_test_id", limit: 4
    t.integer "related_id",  limit: 4
  end

  add_index "lab_tests_lab_tests", ["lab_test_id", "related_id"], name: "related_lab_test_index", using: :btree

  create_table "lab_tests_test_approvals", id: false, force: :cascade do |t|
    t.integer "lab_test_id",      limit: 4
    t.integer "test_approval_id", limit: 4
  end

  create_table "link_types", force: :cascade do |t|
    t.string   "prefix",     limit: 255
    t.string   "suffix",     limit: 255
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "links", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "link",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "marker_mdbids", force: :cascade do |t|
    t.string   "mdbid",             limit: 255
    t.string   "identifiable_type", limit: 255
    t.string   "identifiable_id",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "molecule_bms", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.text     "description",            limit: 65535
    t.string   "wikipedia_link",         limit: 255
    t.string   "kegg_link",              limit: 255
    t.string   "metagene_link",          limit: 255
    t.string   "pubchem_substance_link", limit: 255
    t.string   "pubchem_compound_link",  limit: 255
    t.text     "pdb_file",               limit: 65535
    t.text     "sdf_file",               limit: 65535
    t.text     "mol_file",               limit: 65535
    t.string   "nugowiki_link",          limit: 255
    t.string   "biocyc_link",            limit: 255
    t.string   "bigg_link",              limit: 255
    t.string   "pdb_link",               limit: 255
    t.string   "genbank_link",           limit: 255
    t.string   "omim_link",              limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "source",                 limit: 255
    t.string   "type",                   limit: 255
  end

  create_table "molecule_bms_molecule_bms", id: false, force: :cascade do |t|
    t.integer "molecule_bm_id", limit: 4
    t.integer "similar_id",     limit: 4
  end

  create_table "molecule_bms_references", id: false, force: :cascade do |t|
    t.integer "reference_id",   limit: 4
    t.integer "molecule_bm_id", limit: 4
  end

  create_table "panel_measurements", force: :cascade do |t|
    t.integer  "panel_id",       limit: 4
    t.integer  "measurement_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "panel_measurements", ["measurement_id"], name: "index_panel_measurements_on_measurement_id", using: :btree
  add_index "panel_measurements", ["panel_id"], name: "index_panel_measurements_on_panel_id", using: :btree

  create_table "panels", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "protein_bms", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.text     "description",            limit: 65535
    t.string   "gene_name",              limit: 255
    t.string   "gene_position",          limit: 255
    t.text     "protein_sequence",       limit: 65535
    t.text     "gene_sequence",          limit: 65535
    t.string   "wikipedia_link",         limit: 255
    t.string   "kegg_link",              limit: 255
    t.string   "metagene_link",          limit: 255
    t.string   "pdb_link",               limit: 255
    t.string   "genbank_link",           limit: 255
    t.string   "omim_link",              limit: 255
    t.string   "nugowiki_link",          limit: 255
    t.string   "biocyc_link",            limit: 255
    t.string   "bigg_link",              limit: 255
    t.string   "pubchem_substance_link", limit: 255
    t.text     "pdb_file",               limit: 65535
    t.text     "sdf_file",               limit: 65535
    t.text     "mol_file",               limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "source",                 limit: 255
    t.string   "type",                   limit: 255
  end

  create_table "protein_bms_protein_bms", id: false, force: :cascade do |t|
    t.integer "protein_bm_id", limit: 4
    t.integer "similar_id",    limit: 4
  end

  create_table "protein_bms_references", id: false, force: :cascade do |t|
    t.integer "reference_id",  limit: 4
    t.integer "protein_bm_id", limit: 4
  end

  create_table "proteins", force: :cascade do |t|
    t.string   "name",                         limit: 255
    t.text     "description",                  limit: 65535
    t.string   "gene_name",                    limit: 255
    t.string   "gene_position",                limit: 255
    t.text     "pdb_file",                     limit: 65535
    t.text     "sdf_file",                     limit: 65535
    t.text     "mol_file",                     limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "source",                       limit: 255
    t.string   "protein_type",                 limit: 255
    t.date     "review_date"
    t.string   "uniprot_id",                   limit: 255
    t.text     "general_function",             limit: 65535
    t.string   "uniprot_name",                 limit: 255
    t.string   "genecard_id",                  limit: 255
    t.string   "hgnc_id",                      limit: 255
    t.string   "structure_image_file_name",    limit: 255
    t.string   "structure_image_content_type", limit: 255
    t.integer  "structure_image_file_size",    limit: 4
    t.datetime "structure_image_updated_at"
    t.string   "structure_image_pdb_id",       limit: 255
    t.boolean  "exported"
    t.string   "mdbid",                        limit: 255
    t.text     "panel_single",                 limit: 65535
    t.text     "info_source",                  limit: 65535
  end

  add_index "proteins", ["id"], name: "index_proteins_on_id", using: :btree

  create_table "proteins_proteins", id: false, force: :cascade do |t|
    t.integer "protein_id", limit: 4
    t.integer "similar_id", limit: 4
  end

  create_table "rails_admin_histories", force: :cascade do |t|
    t.text     "message",    limit: 65535
    t.string   "username",   limit: 255
    t.integer  "item",       limit: 4
    t.string   "table",      limit: 255
    t.integer  "month",      limit: 2
    t.integer  "year",       limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], name: "index_rails_admin_histories", using: :btree

  create_table "references", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.text     "citation",    limit: 65535
    t.text     "authors",     limit: 65535
    t.string   "year",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pubmed_id",   limit: 4
    t.date     "review_date"
    t.string   "pages",       limit: 255
    t.string   "embl_id",     limit: 255
    t.string   "medline",     limit: 255
    t.string   "journal",     limit: 255
    t.string   "volume",      limit: 255
    t.string   "issue",       limit: 255
    t.string   "url",         limit: 255
    t.boolean  "fetched"
  end

  add_index "references", ["pubmed_id"], name: "index_references_on_pubmed_id", using: :btree

  create_table "risk_stats", force: :cascade do |t|
    t.float    "frequency",     limit: 24
    t.float    "relative_risk", limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roc_stats", force: :cascade do |t|
    t.float    "roc_auc",            limit: 24
    t.float    "ci_auc_lower",       limit: 24
    t.float    "ci_auc_upper",       limit: 24
    t.float    "sensitivity",        limit: 24
    t.float    "specificity",        limit: 24
    t.integer  "participant_count",  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
    t.text     "roc_conc_threshold", limit: 65535
  end

  create_table "sequence_variant_measurements", force: :cascade do |t|
    t.integer  "condition_id",          limit: 4
    t.integer  "indication_type_id",    limit: 4
    t.integer  "biomarker_category_id", limit: 4
    t.string   "indication_modifier",   limit: 255
    t.string   "comment",               limit: 255
    t.integer  "sequence_variant_id",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quality_id",            limit: 4
    t.string   "quality_type",          limit: 255
    t.string   "approved",              limit: 255
    t.string   "clinical_sig",          limit: 255
    t.text     "logistic_equation",     limit: 65535
    t.text     "roc_curve",             limit: 65535
    t.integer  "pubmed_id",             limit: 4
    t.float    "auroc",                 limit: 24
    t.float    "heritability",          limit: 24
    t.integer  "condition_id_id",       limit: 4
    t.text     "special_constraints",   limit: 65535
  end

  add_index "sequence_variant_measurements", ["biomarker_category_id", "condition_id", "sequence_variant_id"], name: "seqvarmeas_bmcat_cond", using: :btree
  add_index "sequence_variant_measurements", ["condition_id_id"], name: "index_sequence_variant_measurements_on_condition_id_id", using: :btree
  add_index "sequence_variant_measurements", ["quality_id", "quality_type"], name: "seq_var_measurements_qual_id_qual_type", unique: true, using: :btree

  create_table "sequence_variants", force: :cascade do |t|
    t.string   "description",           limit: 255
    t.string   "position",              limit: 255
    t.string   "variation",             limit: 255
    t.string   "gene_symbol",           limit: 255
    t.boolean  "coding"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "gene_id",               limit: 4
    t.integer  "indication_type_id",    limit: 4
    t.integer  "biomarker_category_id", limit: 4
    t.string   "indication_modifier",   limit: 255
    t.string   "comment",               limit: 255
    t.text     "external_type",         limit: 65535
    t.integer  "mdbid_id",              limit: 4
    t.text     "marker_type",           limit: 65535
    t.text     "reference",             limit: 65535
    t.integer  "exported",              limit: 4
    t.integer  "chromosome",            limit: 4
    t.text     "external_url",          limit: 65535
    t.text     "image_url",             limit: 65535
    t.text     "image_id",              limit: 65535
    t.integer  "parent_id",             limit: 4
    t.text     "variation_sequence",    limit: 65535
    t.string   "source",                limit: 255
    t.string   "organism",              limit: 255
  end

  add_index "sequence_variants", ["mdbid_id"], name: "index_sequence_variants_on_mdbid_id", using: :btree

  create_table "sequences", force: :cascade do |t|
    t.string   "type",              limit: 255,   null: false
    t.integer  "sequenceable_id",   limit: 4,     null: false
    t.string   "sequenceable_type", limit: 255,   null: false
    t.string   "header",            limit: 1000,  null: false
    t.text     "chain",             limit: 65535, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uniprot_id",        limit: 255
  end

  add_index "sequences", ["sequenceable_type", "sequenceable_id"], name: "index_on_polymorphic", using: :btree

  create_table "single_nucleotide_polymorphisms", force: :cascade do |t|
    t.string   "snp_id",            limit: 255
    t.float    "auroc",             limit: 24
    t.string   "roc_curve",         limit: 255
    t.text     "logistic_equation", limit: 65535
    t.integer  "pubmed_id",         limit: 4
    t.float    "heritability",      limit: 24
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "gene_id",           limit: 4
    t.integer  "condition_id",      limit: 4
    t.string   "position",          limit: 255
    t.string   "study_id",          limit: 255
    t.string   "gene_symbol",       limit: 255
    t.string   "condition_name",    limit: 255
    t.string   "status",            limit: 255
    t.text     "clin_sig",          limit: 65535
  end

  create_table "snps", force: :cascade do |t|
    t.string   "snp_id",        limit: 255
    t.string   "molecule_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "test_approvals", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "test_uses", force: :cascade do |t|
    t.string   "description",           limit: 255
    t.integer  "lab_test_id",           limit: 4
    t.integer  "condition_id",          limit: 4
    t.integer  "biomarker_category_id", limit: 4
    t.string   "biomarker_class_name",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",               limit: 255, default: "", null: false
    t.string   "encrypted_password",  limit: 128, default: "", null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       limit: 4,   default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",  limit: 255
    t.string   "last_sign_in_ip",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "super"
    t.boolean  "guest"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  create_table "wishart_notices", force: :cascade do |t|
    t.text     "content",    limit: 65535,                 null: false
    t.boolean  "display",                  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
