module ActsAsAliasableTest 
  def self.included(base)
    base.class_exec do 
      should have_many(:aliases)
      should have_db_column(:name).of_type(:string)
    end
  end
end
