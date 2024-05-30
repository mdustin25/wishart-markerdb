require 'test_helper'

class LinkTypeTest < ActiveSupport::TestCase
  def setup
    @type = build :link_type
    @key = "test"
    @default_prefix = "http://www.prefix.com/"
  end

  should validate_presence_of :prefix
  should validate_presence_of :name

  should "Return url" do
    assert_equal "#{@default_prefix}#{@key}/suffix", @type.url(@key)
  end

  should "Return url with empty suffix" do
    @type.suffix = nil
    assert_equal "#{@default_prefix}#{@key}", @type.url(@key)
  end
end
