module ActsAsBiomarkerTest 
  def self.included(base)
    base.class_exec do 
      include ActsAsLinkableTest
      include ActsAsCitationOwnerTest
      include ActsAsLabTestOwnerTest 

      should have_many(:extra_descriptions)
    end
  end
end
