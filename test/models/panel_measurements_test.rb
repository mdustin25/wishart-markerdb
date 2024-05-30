require "test_helper"

class PanelMeasurementsTest < ActiveSupport::TestCase

  def panel_measurements
    @panel_measurements ||= PanelMeasurements.new
  end

  def test_valid
    assert panel_measurements.valid?
  end

end
