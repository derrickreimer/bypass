require 'addressable/uri'
require File.dirname(__FILE__) + '/../test_helper.rb'

class Detour::TextFilterTest < Test::Unit::TestCase
  context "#replace" do
    should "replace URLs" do
      text = "http://yahoo.com"
      filter = Detour::TextFilter.new(text)
      filter.replace { "foo" }
      assert_equal "foo", filter.content
    end

    should "not include trailing periods in urls" do
      text = "http://yahoo.com."
      filter = Detour::TextFilter.new(text)
      filter.replace { "foo" }
      assert_equal "foo.", filter.content
    end
    
    should "not include parenthesis in urls" do
      text = "(http://yahoo.com)"
      filter = Detour::TextFilter.new(text)
      filter.replace { "foo" }
      assert_equal "(foo)", filter.content
    end
    
    should "not include trailing commas in urls" do
      text = "http://yahoo.com,"
      filter = Detour::TextFilter.new(text)
      filter.replace { "foo" }
      assert_equal "foo,", filter.content
    end
  end
end