require 'addressable/uri'
require File.dirname(__FILE__) + '/../test_helper.rb'

class Detour::FilterTest < Test::Unit::TestCase
  context "#to_s" do
    should "return content" do
      filter = Detour::Filter.new("foo")
      assert_equal "foo", filter.to_s
    end
  end
end