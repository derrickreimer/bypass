require File.dirname(__FILE__) + '/../test_helper.rb'

class Bypass::URITest < Test::Unit::TestCase
  context "#append_to_query_values" do
    should "add values to the query string if it starts empty" do
      uri = Bypass::URI.parse("http://www.getdrip.com")
      uri.append_to_query_values(:foo => "bar")
      assert_equal "http://www.getdrip.com?foo=bar", uri.to_s
    end
  end
end