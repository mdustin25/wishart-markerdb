require "test_helper"

class MarkerMdbidTest < ActiveSupport::TestCase
  def marker_mdbid
    @marker_mdbid ||= MarkerMdbid.new
  end

  def test_valid
    assert marker_mdbid.valid?
  end
end
