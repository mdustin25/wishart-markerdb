require 'test_helper'

class BiomarkerTest < ActiveSupport::TestCase
  
  should "return a list of Models that include Biomarker module" do
    class MockBm
      def self.include?(klass)
        klass == Biomarker
      end
    end
    class NotBm; end
    ActiveRecord::Base.stubs :descendants => [MockBm,NotBm]
    assert_equal Biomarker.models, [MockBm]
  end

  should "generate mdbid" do
    MockBm = Chemical

    bm = MockBm.new
    bm.stubs(:marker_tag).returns("G")

    # test base 36 ids
    bm.id = 0
    assert_equal "MG000", bm.mdbid 
    assert_equal bm.id, Biomarker.mdbid_to_id(bm.mdbid)

    bm.id = 4 * 36
    assert_equal "MG040", bm.mdbid
    assert_equal bm.id, Biomarker.mdbid_to_id(bm.mdbid)

    bm.id = 11 * 36 + 2
    assert_equal "MG0B2", bm.mdbid
    assert_equal bm.id, Biomarker.mdbid_to_id(bm.mdbid)

    bm.id = 20 * 36**2 + 11 * 36 + 2
    assert_equal "MGKB2", bm.mdbid
    assert_equal bm.id, Biomarker.mdbid_to_id(bm.mdbid)

    bm.id = 4 * 36**3
    assert_equal "MG4000", bm.mdbid
    assert_equal bm.id, Biomarker.mdbid_to_id(bm.mdbid)
  end

end

