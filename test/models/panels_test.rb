require "test_helper"

class PanelsTest < ActiveSupport::TestCase

  def panels
    @panels ||= Panels.new
  end

  def test_valid
    assert panels.valid?
  end

end
