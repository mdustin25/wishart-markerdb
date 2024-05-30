module ActsAsLinkableTest 
  def self.included(base)
    base.class_exec do 
      should have_many(:external_links)
    end
  end
end
