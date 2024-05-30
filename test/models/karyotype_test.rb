require 'test_helper'

class KaryotypeTest < ActiveSupport::TestCase
  should have_db_column(:karyotype).of_type(:string)
end
