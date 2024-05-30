require 'test_helper'

class ExternalLinkTest < ActiveSupport::TestCase
  def setup
    @link = build(:external_link)
    @type = @link.link_type
  end

  should belong_to(:linkable)
  should belong_to(:link_type)

  context "Without a custom url or name" do
    setup do
      @link.name = nil
      @link.url  = nil
    end

    should "save with a type" do
      assert @link.save
    end

    should "not save without a type" do
      @link.link_type = nil
      assert !@link.save
    end

    should "not save without a key" do
      @link.key = nil
      assert !@link.save
    end

    should "return url from type" do
      assert_equal @link.url, @type.url(@link.key)
    end

    should "return name from type" do
      assert_equal @link.name, @type.name
    end
  end

  context "With custom url and name" do
    setup do
      @custom_url  = "http://www.custom.com"
      @custom_name = "custom name"
      @link.url    = @custom_url
      @link.name   = @custom_name
    end

    should "save without a type" do
      @link.link_type = nil
      assert @link.save
    end

    should "return custom url" do
      assert_equal @link.url, @custom_url
    end

    should "return custom name" do
      assert_equal @link.name, @custom_name
    end
  end

  should "be able to set link type by string or object" do
    type = create(:link_type,:name => "some_db")
    
    with_object = ExternalLink.new(:key => "test")
    with_object.link_type = type
    assert with_object.save
    assert_equal type, with_object.link_type

    with_string = ExternalLink.new(:key => "test")
    with_string.link_type_name = "some_db"
    assert with_string.save
    assert_equal type, with_string.link_type
    

    attributes = @link.attributes
    attributes.delete(:id); attributes.delete(:link_type_id)
    attributes[:link_type_name] = "some_db"
    with_hash = ExternalLink.new(attributes)
    assert with_hash.save
    assert_equal type, with_hash.link_type
  end

  should "have method called link_type_name" do
    assert_equal @type.name, @link.link_type_name
  end

  should "create link_type if it doesn't exist" do
    with_string = ExternalLink.new(:key => "test")
    with_string.link_type_name = "some_db"
    assert with_string.save, "should save"
  end

end

