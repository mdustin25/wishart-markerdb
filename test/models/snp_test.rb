require 'test_helper'

class SnpTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: snps
#
#  id            :integer(4)      not null, primary key
#  snp_id        :string(255)
#  molecule_type :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

