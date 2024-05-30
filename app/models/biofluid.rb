# == Schema Information
# Schema version: 20110511004139
#
# Table name: biofluids
#
#  id   :integer(4)      not null, primary key
#  name :string(255)
#

class Biofluid < ActiveRecord::Base
  #include LabTestOwner 
  has_and_belongs_to_many :lab_tests
end
