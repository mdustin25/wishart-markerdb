require 'test_helper'

class ReferenceTest < ActiveSupport::TestCase
  should have_many(:citations)
  should have_many(:citation_owners).through(:citations)

  should have_db_column(:title).of_type(:string)
  should have_db_column(:citation).of_type(:text)
  should have_db_column(:authors).of_type(:text)
  should have_db_column(:year).of_type(:string)
  should have_db_column(:pubmed_id).of_type(:integer)
  should have_db_column(:review_date).of_type(:date)

  should "fetch information from pubmed when created by pubmed id" do
    pubmed_id = 17202168
    created_ref = Reference.create_from_pubmed_id(pubmed_id)
    assert_equal created_ref.title, "HMDB: the Human Metabolome Database."
    assert created_ref.fetched?
  end

  should "not recreate the reference if the existing reference if already fetched" do
    pubmed_id = 17202168
    Reference.create_from_pubmed_id(pubmed_id)
    Reference.find_or_create_by_pubmed_id(pubmed_id)
    assert_equal 1, Reference.count
  end
end
