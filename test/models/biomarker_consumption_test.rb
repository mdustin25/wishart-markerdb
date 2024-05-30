require "test_helper"

class BiomarkerConsumptionTest < ActiveSupport::TestCase
  def biomarker_consumption
    @biomarker_consumption ||= BiomarkerConsumption.new
  end

  def test_valid
    assert biomarker_consumption.valid?
  end
end
