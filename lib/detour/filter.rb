require 'uri'
require 'nokogiri'

module Detour
  class Filter
    attr_accessor :text
    attr_reader :options
    
    URL_PATTERN = /\bhttps?:\/\/
      [a-zA-Z0-9\-\._~:\/\?#\[\]@!$&'\(\)\*\+,;=%]+
      [a-zA-Z0-9\-_~:\/\?#\[\]@!$&\*\+;=%]/x
    
    def initialize(text, options = {})
      @text = text
      @options = options
    end
    
    def replace(&block)
      parsed_text.traverse do |node|
        case node.name
        when "text"
          unless node.path.split("/").include?("a")
            text = node.text
            replace_text_urls!(text) { |url| yield(url) }
            node.content = text
          end
        when "a"
          node.set_attribute("href", yield(node.get_attribute("href")))
        end
      end
      
      self.text = parsed_text.to_s
    end
  
  private
  
    def replace_text_urls!(text, &block)
      text.gsub!(URL_PATTERN) do |match|
        yield(match.to_s)
      end
    end
    
    def parsed_text
      @parsed_text ||= Nokogiri::HTML::DocumentFragment.parse(text)
    end
  end
end