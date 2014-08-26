require 'addressable/uri'
require File.dirname(__FILE__) + '/../test_helper.rb'

class Bypass::HTMLFilterTest < MiniTest::Test
  context "#replace" do
    should "replace hrefs" do
      text = "<a href=\"http://yahoo.com\">Yahoo</a>"
      filter = Bypass::HTMLFilter.new(text)
      filter.replace { "foo" }
      assert_equal "<a href=\"foo\">Yahoo</a>", filter.content
    end

    should "handle cases when there is no href attribute" do
      text = "<a>Yahoo</a>"
      filter = Bypass::HTMLFilter.new(text)
      filter.replace { "foo" }
      assert_equal "<a>Yahoo</a>", filter.content
    end

    should "skip malformed URLs" do
      text = "<a href=\"http://#\">Yahoo</a>"
      filter = Bypass::HTMLFilter.new(text)
      filter.replace { "foo" }
      assert_equal text, filter.content
    end

    should "strip whitespace around URLs" do
      text = "<a href=\"http://example.com \">Example</a>"
      filter = Bypass::HTMLFilter.new(text)
      filter.replace do |url|
        url.append_to_query_values(:foo => "bar")
        url
      end
      expected = "<a href=\"http://example.com?foo=bar\">Example</a>"
      assert_equal expected, filter.content
    end
  end

  context "#auto_link" do
    should "convert plain URLs into links" do
      text = "Hello http://www.google.com."
      filter = Bypass::HTMLFilter.new(text)
      filter.auto_link
      assert_equal "Hello <a href=\"http://www.google.com\">http://www.google.com</a>.", filter.content
    end

    should "not replace urls inside a-tags" do      
      text = "<a href=\"http://yahoo.com\">http://yahoo.com</a>"
      filter = Bypass::HTMLFilter.new(text)
      filter.auto_link
      assert_equal text, filter.content
    end
  end

  context "#build_anchor_tag" do
    should "use the right text and href" do
      filter = Bypass::HTMLFilter.new("")
      tag = "<a href=\"http://www.google.com\">Google</a>"
      assert_equal tag, filter.build_anchor_tag("Google", "http://www.google.com")
    end
    
    should "include additional attributes" do
      filter = Bypass::HTMLFilter.new("")
      tag = "<a href=\"http://www.google.com\" class=\"button\">Google</a>"
      assert_equal tag, filter.build_anchor_tag("Google", "http://www.google.com", :class => "button")
    end
  end

  context "#content" do
    should "cast parsed content to string" do
      filter = Bypass::HTMLFilter.new("")
      filter.expects(:parsed_content).returns(stub(:to_s => "bar"))
      assert_equal "bar", filter.content
    end

    should "handle document fragments" do
      filter = Bypass::HTMLFilter.new("<div>text</div>")
      assert_equal "<div>text</div>", filter.content
    end

    should "handle whole documents" do
      lines = []

      lines << "<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\" \"http://www.w3.org/TR/REC-html40/loose.dtd\">"
      lines << "<html>"
      lines << "  <head></head>"
      lines << "  <body>"
      lines << "    <div>Content</div>"
      lines << "  </body>"
      lines << "</html>"

      document = lines.join("\n")
      expected = document.sub("<head></head>", "<head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\"></head>")

      filter = Bypass::HTMLFilter.new(document, :fragment => false)
      assert_equal expected.strip, filter.content.strip
    end
  end
end