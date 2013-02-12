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
      
      assert_equal urls, result
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
      
      assert_equal urls, result
    end
    
    should "yield hrefs and plain-text URLs" do
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
      
      assert_equal urls, result
    end
  end
end