require 'test_helper'

class AliasableTest < ActiveSupport::TestCase

  context "An aliasable model" do
    setup do
      @aliased_model = Chemical.new

      @name = "Real Name"
      @attributes = {"name" => @name}

      @alias_list = build_list :alias, 3
      @aliases = @alias_list

      @aliased_model.stubs(:attributes).returns(@attributes)
      @aliased_model.stubs(:aliases).returns(@aliases)
    end

    context "with aliases" do
      should "return all names" do
        assert_equal [@name] + @alias_list.map(&:name),
          @aliased_model.names
      end
    end

    context "without aliases" do
      setup do
        @aliased_model.stubs(:aliases).returns([])
      end

      should "return only real name" do
        assert_equal [@name], @aliased_model.names
      end
    end

    context "with aliases but without a name" do
      setup{ @attributes["name"] = nil }
      should "return only aliases" do
        assert_equal @alias_list.map(&:name),
          @aliased_model.names
      end
    end
  end

end


