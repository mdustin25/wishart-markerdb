require "test_helper"

class RiskStatsTest < ActiveSupport::TestCase

  def risk_stats
    @risk_stats ||= RiskStats.new
  end

  def test_valid
    assert risk_stats.valid?
  end

end
