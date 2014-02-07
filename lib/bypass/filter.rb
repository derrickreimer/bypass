module Bypass
  class Filter
    attr_reader :content
    
    URL_PATTERN = /\bhttps?:\/\/
      [a-zA-Z0-9\-\._~:\/\?#\[\]@!$&'\(\)\*\+,;=%]+
      [a-zA-Z0-9\-_~:\/\?#\[\]@!$&\*\+;=%]/x
    
    def initialize(content)
      @content = content.to_s
    end

    def replace
      raise NotImplementedError
    end
    
    def to_s
      content
    end
  
  private
  
    def gsub_urls(text, &block)
      text.gsub(URL_PATTERN) do |match|
        yield(match.to_s)
      end
    end

    def parse_uri(uri)
      Bypass::URI.parse(uri)
    rescue => ex
      nil
    end
  end
end