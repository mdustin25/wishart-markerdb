require "test_helper"

class SequenceTest < ActiveSupport::TestCase
  def sequence
    @sequence ||= Sequence.new
  end

  def test_valid
    assert sequence.valid?
  end
end
