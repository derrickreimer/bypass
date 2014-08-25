module Bypass
  class Filter
    attr_reader :content, :fragment
    
    URL_PATTERN = /\bhttps?:\/\/
      [a-zA-Z0-9\-\._~:\/\?#\[\]@!$&'\(\)\*\+,;=%]+
      [a-zA-Z0-9\-_~:\/\?#\[\]@!$&\*\+;=%]/x
    
    def initialize(content, options = { :fragment => true })
      @content = content.to_s
      @fragment = options[:fragment]
    end

    def replace
      raise NotImplementedError
    end
    
    def to_s
      content
    end

    def is_fragment?
      fragment
    end
  
  private
  
    def gsub_urls(text, &block)
      text.gsub(URL_PATTERN) do |match|
        yield(match.to_s)
      end
    end

    def parse_uri(uri)
      Bypass::URI.parse(uri.to_s.strip)
    rescue => ex
      nil
    end
  end
end