class GetRidOfOldTables < ActiveRecord::Migration
  def self.up
    # remove tables joining aliases
    remove_index "protein_bm_aliases", :name => "index_protein_bm_aliases_on_protein_bm_id"
    remove_index "molecule_bm_aliases", :name => "index_molecule_bm_aliases_on_molecule_bm_id"
    remove_index "genetic_bm_aliases", :name => "index_genetic_bm_aliases_on_genetic_bm_id"
    remove_index "condition_aliases", :name => "index_condition_aliases_on_condition_id"
    remove_index "allele_aliases", :name => "index_allele_aliases_on_allele_id"
    drop_table "protein_bm_aliases"
    drop_table "molecule_bm_aliases"
    drop_table "genetic_bm_aliases"
    drop_table "diagnostic_test_aliases"
    drop_table "condition_aliases"
    drop_table "allele_aliases"

    # remove protein/molecule levels (replaced with concentration)
    remove_index "protein_levels", :name => "index_protein_levels_on_id"
    remove_index "molecule_levels", :name => "index_molecule_levels_on_molecule_bm_id"
    drop_table "molecule_levels"
    drop_table "protein_levels"

    # remove tables joining diagnostic tests
    remove_index "bm_levels_diagnostic_tests", :name => "index_bm_levels_diagnostic_tests_on_bm_level_id"
    drop_table "diagnostic_tests_protein_levels"
    drop_table "diagnostic_tests_protein_bms"
    drop_table "diagnostic_tests_molecule_levels"
    drop_table "diagnostic_tests_molecule_bms"
    drop_table "diagnostic_tests_genetic_bms"
    drop_table "bm_levels_diagnostic_tests"

    # remove tables joining alleles
    remove_index "alleles_diagnostic_tests", :name => "index_alleles_diagnostic_tests_on_allele_id"
    remove_index "alleles", :name => "index_alleles_on_genetic_bm_id"
    remove_index "alleles", :name => "index_alleles_on_condition_id"
    remove_index "alleles_diagnostic_tests", :name => "index_alleles_diagnostic_tests_on_allele_id"
    drop_table "alleles_diagnostic_tests"
    drop_table "alleles"

    # remove tables joining references
    remove_index "alleles_references", :name => "index_alleles_references_on_reference_id"
    remove_index "alleles_references", :name => "index_alleles_references_on_allele_id"
    drop_table "protein_levels_references"
    drop_table "protein_bms_references"
    drop_table "molecule_levels_references"
    drop_table "molecule_bms_references"
    drop_table "genetic_bms_references"
    drop_table "diagnostic_tests_references"
    drop_table "conditions_references"
    drop_table "bm_levels_references"
    drop_table "alleles_references"

  end

  def self.down
    # remove tables joining aliases
    create_table "condition_aliases", :force => true do |t| 
    end
    create_table "diagnostic_test_aliases", :force => true do |t| 
    end
    create_table "genetic_bm_aliases", :force => true do |t| 
    end
    create_table "molecule_bm_aliases", :force => true do |t| 
    end
    create_table "protein_bm_aliases", :force => true do |t| 
    end
    create_table "allele_aliases", :force => true do |t| 
    end

    # remove tables joining references
    create_table "alleles_references", :id => false, :force => true do |t|
    end
    create_table "bm_levels_references", :id => false, :force => true do |t|
    end
    create_table "conditions_references", :id => false, :force => true do |t|
    end
    create_table "diagnostic_tests_references", :id => false, :force => true do |t|
    end
    create_table "genetic_bms_references", :id => false, :force => true do |t|
    end
    create_table "molecule_bms_references", :id => false, :force => true do |t|
    end
    create_table "molecule_levels_references", :id => false, :force => true do |t|
    end
    create_table "protein_bms_references", :id => false, :force => true do |t|
    end
    create_table "protein_levels_references", :id => false, :force => true do |t|
    end

    # remove tables joining alleles
    create_table "alleles", :force => true do |t|
    end
    create_table "alleles_diagnostic_tests", :id => false, :force => true do |t|
    end
    create_table "alleles_diagnostic_tests", :id => false, :force => true do |t|
    end
    # remove tables joining diagnostic tests
    create_table "bm_levels_diagnostic_tests", :id => false, :force => true do |t|
    end
    create_table "diagnostic_tests_genetic_bms", :id => false, :force => true do |t|
    end
    create_table "diagnostic_tests_molecule_bms", :id => false, :force => true do |t|
    end
    create_table "diagnostic_tests_molecule_levels", :id => false, :force => true do |t|
    end
    create_table "diagnostic_tests_protein_bms", :id => false, :force => true do |t|
    end
    create_table "diagnostic_tests_protein_levels", :id => false, :force => true do |t|
    end

    # remove protein/molecule levels (replaced with concentration)
    create_table "molecule_levels", :force => true do |t|
    end
    create_table "protein_levels", :force => true do |t|
    end

    add_index "protein_levels", ["id"], :name => "index_protein_levels_on_id"
    add_index "molecule_levels", ["molecule_bm_id"], :name => "index_molecule_levels_on_molecule_bm_id"
    add_index "allele_aliases", ["allele_id"], :name => "index_allele_aliases_on_allele_id"
    add_index "protein_bm_aliases", ["protein_bm_id"], :name => "index_protein_bm_aliases_on_protein_bm_id"
    add_index "condition_aliases", ["condition_id"], :name => "index_condition_aliases_on_condition_id"
    add_index "genetic_bm_aliases", ["genetic_bm_id"], :name => "index_genetic_bm_aliases_on_genetic_bm_id"
    add_index "molecule_bm_aliases", ["molecule_bm_id"], :name => "index_molecule_bm_aliases_on_molecule_bm_id"
    add_index "alleles_references", ["allele_id"], :name => "index_alleles_references_on_allele_id"
    add_index "alleles_references", ["reference_id"], :name => "index_alleles_references_on_reference_id"
    add_index "alleles", ["condition_id"], :name => "index_alleles_on_condition_id"
    add_index "alleles", ["genetic_bm_id"], :name => "index_alleles_on_genetic_bm_id"
    add_index "alleles_diagnostic_tests", ["allele_id"], :name => "index_alleles_diagnostic_tests_on_allele_id"
    add_index "alleles_diagnostic_tests", ["allele_id"], :name => "index_alleles_diagnostic_tests_on_allele_id"
    add_index "bm_levels_diagnostic_tests", ["bm_level_id"], :name => "index_bm_levels_diagnostic_tests_on_bm_level_id"
  end

end
