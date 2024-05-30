class LabTestOwnership < ActiveRecord::Base
  belongs_to :lab_test_owner, 
    :polymorphic => true
  belongs_to :lab_test

  def owner; lab_test_owner; end

  def self.biomarkers  
    where(:lab_test_owner_type => Biomarker.models.map(&:name))
  end

end

# == Schema Information
#
# Table name: lab_test_ownerships
#
#  id                  :integer(4)      not null, primary key
#  lab_test_owner_id   :integer(4)
#  lab_test_owner_type :string(255)
#  lab_test_id         :integer(4)
#

