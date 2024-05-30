module ActsAsMeasurementTest 
  def self.included(base)
    base.class_exec do 
      include ActsAsLinkableTest
      include ActsAsCitationOwnerTest

      should belong_to(:condition)
      should belong_to(:indication_type)
      should belong_to(:biomarker_category)
      should have_db_column(:indication_modifier).of_type(:string)
      should have_db_column(:comment).of_type(:string)

      should validate_presence_of(:condition)
      should validate_presence_of(:indication_type)

      should "call measures to set up the model" do
        klass = base.name[0..-5].constantize
        assert klass.biomarker_model, "biomarker_model not set"
        assert klass.biomarker_getter, "biomarker_getter not set"
      end

    end
  end
end
