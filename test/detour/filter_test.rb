require File.dirname(__FILE__) + '/../test_helper.rb'

class Detour::FilterTest < Test::Unit::TestCase
  context "#replace" do
    setup do
      @urls = {
        :google => "http://www.google.com/",
        :yahoo => "http://www.yahoo.com/",
        :twitter => "https://twitter.com/"
      }
    end
    
    should "yield plain-text URLs" do
      result = []
      urls = [@urls[:google], @urls[:yahoo]]
      text = <<-END
        Chuck sirloin beef ribs jowl prosciutto pancetta meatball 
        #{@urls[:google]}. Jowl leberkas meatball, short ribs sausage 
        tail andouille chicken (#{@urls[:yahoo]}) tenderloin.
      END
      
      Detour::Filter.new(text).replace do |url|
        result << url
      end
      
      assert_equal urls.sort, result.sort
    end
    
    should "yield hrefs" do
      result = []
      urls = [@urls[:twitter]]
      text = <<-END
        Chuck sirloin beef ribs jowl prosciutto pancetta meatball 
        Jowl leberkas meatball, <a href="#{@urls[:twitter]}">Link</a> 
        short ribs sausage tail andouille chicken tenderloin.
      END
      
      Detour::Filter.new(text).replace do |url|
        result << url
      end
      
      assert_equal urls.sort, result.sort
    end
    
    should "yield hrefs and plain-text urls" do
      result = []
      urls = [@urls[:google], @urls[:yahoo], @urls[:twitter]]
      text = <<-END
        Bacon ipsum dolor sit amet swine spare ribs chuck sirloin beef ribs 
        jowl prosciutto pancetta meatball (#{@urls[:google]}).
        <a href="#{@urls[:yahoo]}">Yahoo</a>
        Follow us on Twitter at #{@urls[:twitter]}.
      END
      
      Detour::Filter.new(text).replace do |url|
        result << url
      end
      
      assert_equal urls.sort, result.sort
    end
    
    should "replace urls" do
      replacements = ["GOOGLE", "YAHOO"]
      text = "#{@urls[:google]} <a href=\"#{@urls[:yahoo]}\">Yahoo</a>"
      filter = Detour::Filter.new(text)
      filter.replace { replacements.shift }
      assert_equal "GOOGLE <a href=\"YAHOO\">Yahoo</a>", filter.text
    end
    
    should "not replace urls inside a-tags" do      
      text = "<a href=\"#{@urls[:yahoo]}\">#{@urls[:yahoo]}</a>"
      filter = Detour::Filter.new(text)
      filter.replace { "YAHOO" }
      assert_equal "<a href=\"YAHOO\">#{@urls[:yahoo]}</a>", filter.text
    end
    
    should "not include trailing periods in urls" do
      text = "#{@urls[:yahoo]}."
      filter = Detour::Filter.new(text)
      filter.replace { "YAHOO" }
      assert_equal "YAHOO.", filter.text
    end
    
    should "not include parenthesis in urls" do
      text = "(#{@urls[:yahoo]})"
      filter = Detour::Filter.new(text)
      filter.replace { "YAHOO" }
      assert_equal "(YAHOO)", filter.text
    end
    
    should "not include trailing commas in urls" do
      text = "#{@urls[:yahoo]},"
      filter = Detour::Filter.new(text)
      filter.replace { "YAHOO" }
      assert_equal "YAHOO,", filter.text
    end
  end
  
  context "#auto_link" do
    setup do
      @urls = {
        :google => "http://www.google.com/",
        :yahoo => "http://www.yahoo.com/",
        :twitter => "https://twitter.com/"
      }
    end
    
    should "auto link plain text URLs" do
      text = <<-END
        Chuck #{@urls[:google]}. Jowl leberkas, 
        andouille chicken (#{@urls[:yahoo]}) 
        tenderloin.
      END
      
      linked_text = <<-END
        Chuck <a href="#{@urls[:google]}">#{@urls[:google]}</a>. Jowl leberkas, 
        andouille chicken (<a href="#{@urls[:yahoo]}">#{@urls[:yahoo]}</a>) 
        tenderloin.
      END
      
      filter = Detour::Filter.new(text)
      assert_equal linked_text, filter.auto_link.text
    end
  end
  
  context "#anchor_tag" do
    should "use the right text and href" do
      filter = Detour::Filter.new("")
      tag = "<a href=\"http://www.google.com\">Google</a>"
      assert_equal tag, filter.anchor_tag("Google", "http://www.google.com")
    end
    
    should "include allowed attributes" do
      filter = Detour::Filter.new("")
      tag = "<a href=\"http://www.google.com\" class=\"button\">Google</a>"
      assert_equal tag, filter.anchor_tag("Google", "http://www.google.com", :class => "button")
    end
    
    should "not include text option" do
      filter = Detour::Filter.new("")
      tag = "<a href=\"http://www.google.com\">Google</a>"
      assert_equal tag, filter.anchor_tag("Google", "http://www.google.com", :text => "foo")
      assert_equal tag, filter.anchor_tag("Google", "http://www.google.com", "text" => "foo")
    end
    
    should "not include href option" do
      filter = Detour::Filter.new("")
      tag = "<a href=\"http://www.google.com\">Google</a>"
      assert_equal tag, filter.anchor_tag("Google", "http://www.google.com", :href => "foo")
      assert_equal tag, filter.anchor_tag("Google", "http://www.google.com", "href" => "foo")
    end
  end
end