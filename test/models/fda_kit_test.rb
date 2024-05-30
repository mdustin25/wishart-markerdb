require 'test_helper'

class FdaKitTest < ActiveSupport::TestCase
  should belong_to(:lab_test)

end


# == Schema Information
#
# Table name: fda_kits
#
#  id            :integer(4)      not null, primary key
#  doc_number    :string(255)
#  company       :string(255)
#  name          :string(255)
#  approved_date :date
#  lab_test_id   :integer(4)
#

