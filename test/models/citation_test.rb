require 'test_helper'

class CitationTest < ActiveSupport::TestCase
  should have_db_column(:reference_id).of_type(:integer)
  should belong_to(:citation_owner)
  should belong_to(:reference)
  should validate_presence_of(:citation_owner)
  should validate_presence_of(:reference)

  should "have virtual attribute to set reference by pubmedid" do
    ref = create(:reference, :pubmed_id => 1001)
    owner = create(:gene)
    citation = Citation.new(
      :pubmed_id      => ref.pubmed_id,
      :citation_owner => owner
    )
    assert citation.save
    assert_equal ref, citation.reference
    assert_equal ref.pubmed_id, citation.pubmed_id  
  end
end

# == Schema Information
#
# Table name: citations
#
#  id                  :integer(4)      not null, primary key
#  citation_owner_id   :integer(4)
#  citation_owner_type :string(255)
#  reference_id        :integer(4)
#

