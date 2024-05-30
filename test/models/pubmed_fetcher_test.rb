require 'test_helper'

class PubmedFetcherTest < ActiveSupport::TestCase
  setup do
    @pubmed_ids = [24023812,25545545]
  end

  # Testing the real API so that we know it works
  should "fetch a list of reference objects given a list of pubmed ids" do
    result = PubmedFetcher.fetch(@pubmed_ids)
    assert_equal "The human urine metabolome.", result.first.title
    assert_equal "Circadian variation of the human metabolome captured by real-time breath analysis.", result.last.title
  end

end

