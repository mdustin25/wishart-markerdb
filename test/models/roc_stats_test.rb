require "test_helper"

class RocStatsTest < ActiveSupport::TestCase

  def roc_stats
    @roc_stats ||= RocStats.new
  end

  def test_valid
    assert roc_stats.valid?
  end

end
