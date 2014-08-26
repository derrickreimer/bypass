module Bypass
  class Filter
    attr_reader :content, :fragment
    
    URL_PATTERN = /\bhttps?:\/\/
      [a-zA-Z0-9\-\._~:\/\?#\[\]@!$&'\(\)\*\+,;=%]+
      [a-zA-Z0-9\-_~:\/\?#\[\]@!$&\*\+;=%]/x
    
    def initialize(content, options = {})
      @content = content.to_s.encode("UTF-8")
      @fragment = options.fetch(:fragment, true)
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
      Bypass::URI.parse(uri.to_s.strip)
    rescue => ex
      nil
    end
  end
end