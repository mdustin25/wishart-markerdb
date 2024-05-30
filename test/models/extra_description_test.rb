require 'test_helper'

class ExtraDescriptionTest < ActiveSupport::TestCase
  include ActsAsLinkableTest

  should have_db_column(:description).of_type(:text)
  should have_db_column(:source).of_type(:string)
  should belong_to(:describable)
end

# == Schema Information
#
# Table name: extra_descriptions
#
#  id               :integer(4)      not null, primary key
#  description      :text
#  source           :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  describable_id   :integer(4)
#  describable_type :string(255)
#

