module ActsAsCitationOwnerTest 
  def self.included(base)
    base.class_exec do 
      should have_many(:citations)
      should have_many(:references)
    end
  end
end
