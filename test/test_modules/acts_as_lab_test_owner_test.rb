module ActsAsLabTestOwnerTest 
  def self.included(base)
    base.class_exec do 
      should have_many(:lab_test_ownerships)
      should have_many(:lab_tests).
        through(:lab_test_ownerships)
    end
  end
end
