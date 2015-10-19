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

    should "append to the existing query string" do
      uri = Bypass::URI.parse("http://www.getdrip.com?foo=bar")
      uri.append_to_query_values(:name => "Ian")
      assert_equal "http://www.getdrip.com?foo=bar&name=Ian", uri.to_s
    end

    should "support array-style keys" do
      uri = Bypass::URI.parse("http://www.getdrip.com?foo[]=bar1&foo[]=bar2")
      uri.append_to_query_values(:name => "Ian")
      assert_equal "http://www.getdrip.com?foo[]=bar1&foo[]=bar2&name=Ian", uri.to_s
    end

    should "not attempt to merge duplicate keys" do
      uri = Bypass::URI.parse("http://www.getdrip.com?name=Ian")
      uri.append_to_query_values(:name => "Derrick")
      assert_equal "http://www.getdrip.com?name=Ian&name=Derrick", uri.to_s
    end

    should "encode keys" do
      uri = Bypass::URI.parse("http://www.getdrip.com")
      uri.append_to_query_values("first name" => "Ian")
      assert_equal "http://www.getdrip.com?first+name=Ian", uri.to_s
    end

    should "encode values" do
      uri = Bypass::URI.parse("http://www.getdrip.com")
      uri.append_to_query_values(:name => "Ian Nance")
      assert_equal "http://www.getdrip.com?name=Ian+Nance", uri.to_s
    end
  end
end
