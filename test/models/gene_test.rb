require 'test_helper'

class GeneTest < ActiveSupport::TestCase
  should have_many :sequence_variants
  should have_many(:sequence_variant_measurements).
    through(:sequence_variants)

  should have_db_column(:name).of_type(:string)
  should have_db_column(:description).of_type(:text)
  should have_db_column(:sequence).of_type(:text)
  should have_db_column(:gene_symbol).of_type(:string)
  should have_db_column(:position).of_type(:string)
  should have_db_column(:dominance).of_type(:string)
  should have_db_column(:genetic_type).of_type(:string)
  should have_db_column(:source_common).of_type(:string)
  should have_db_column(:source_taxname).of_type(:string)
  should have_db_column(:review_date).of_type(:date)
end
