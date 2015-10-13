require File.dirname(__FILE__) + '/../test_helper.rb'

class Bypass::URITest < MiniTest::Test
  context "#append_to_query_values" do
    should "add values to the query string if it starts empty" do
      uri = Bypass::URI.parse("http://www.getdrip.com")
      uri.append_to_query_values(:foo => "bar")
      assert_equal "http://www.getdrip.com?foo=bar", uri.to_s
    end

    should "add mulitple values" do
      uri = Bypass::URI.parse("http://www.getdrip.com")
      uri.append_to_query_values(:foo => "bar", :name => "Ian")
      assert_equal "http://www.getdrip.com?foo=bar&name=Ian", uri.to_s
    end

    should "add values to the query string if it starts with values" do
      uri = Bypass::URI.parse("http://www.getdrip.com?foo=bar")
      uri.append_to_query_values(:name => "Ian")
      assert_equal "http://www.getdrip.com?foo=bar&name=Ian", uri.to_s
    end

    should "supoort arrays" do
      uri = Bypass::URI.parse("http://www.getdrip.com?foo[]=bar1&foo[]=bar2")
      uri.append_to_query_values(:name => "Ian")
      assert_equal "http://www.getdrip.com?foo[]=bar1&foo[]=bar2&name=Ian", uri.to_s
    end
  end
end