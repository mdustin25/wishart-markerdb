require 'test_helper'

class MeasurementTest < ActiveSupport::TestCase

  context "setting up a measurement class" do
    setup do
      class MockMeasurable; end
      class MockMeasurable
        def self.belongs_to(*args);end
        def self.has_many(*args);end
        def self.validates(*args);end
        def self.accepts_nested_attributes_for(*args);end
        include Measurement
        measurement_of :active_record, :record
      end
    end

    should "be able to set a biomarker module" do
      assert_equal ActiveRecord, MockMeasurable.biomarker_model
    end

    should "set the method to call with biomarker" do
      object = MockMeasurable.new
      object.expects(:record)
      object.biomarker
    end
  end

end
