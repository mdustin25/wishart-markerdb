# creates a has_many relationship with model_name_aliases
# and creates a method called aliases
module LabTestOwner 
  extend ActiveSupport::Concern

  included do
    has_many :lab_test_ownerships, 
      :as => :lab_test_owner
    has_many :lab_tests,     
      :through => :lab_test_ownerships
  end
end


