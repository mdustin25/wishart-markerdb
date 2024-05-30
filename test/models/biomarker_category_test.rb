require 'test_helper'

class BiomarkerCategoryTest < ActiveSupport::TestCase
  should have_db_column(:name).of_type(:string)
  should have_db_column(:description).of_type(:string)
  should validate_uniqueness_of(:name)
end
