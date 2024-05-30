require 'test_helper'

class AliasTest < ActiveSupport::TestCase
  should have_db_column(:name).of_type(:string)
  should belong_to(:aliasable)
  should validate_uniqueness_of(:name)

end

# == Schema Information
#
# Table name: aliases
#
#  id             :integer(4)      not null, primary key
#  name           :string(255)
#  aliasable_id   :integer(4)
#  aliasable_type :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

