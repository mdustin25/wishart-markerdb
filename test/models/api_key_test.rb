require "test_helper"

class ApiKeyTest < ActiveSupport::TestCase
  def api_key
    @api_key ||= ApiKey.new
  end

  def test_valid
    assert api_key.valid?
  end
end
