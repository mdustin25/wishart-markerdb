require "test_helper"

class AdminUserTest < ActiveSupport::TestCase

  def admin_user
    @admin_user ||= create :admin_user
  end

  def test_valid
    assert admin_user.valid?
  end

end
