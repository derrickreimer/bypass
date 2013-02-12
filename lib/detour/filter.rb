require 'uri'
require 'nokogiri'

module Detour
  class Filter
    attr_reader :text, :options
    
    URL_PATTERN = /\bhttps?:\/\/
      [a-zA-Z0-9\-\._~:\/\?#\[\]@!$&'\(\)\*\+,;=%]+
      [a-zA-Z0-9\-_~:\/\?#\[\]@!$&\*\+,;=%]/x
    
    def initialize(text, options = {})
      @text = text
      @options = options
    end
    
    def parsed_text
      @parsed_text ||= Nokogiri::HTML::DocumentFragment.parse(text)
    end
    
    def replace_text_urls!(text, &block)
      text.gsub!(URL_PATTERN) do |match|
        yield(match.to_s)
      end
    end
    
    def replace(&block)
      parsed_text.traverse do |node|
        case node.name
        when "text"
          replace_text_urls!(node.text) { |url| yield(url) }
        when "a"
          node.set_attribute("href", yield(node.get_attribute("href")))
        end
      end
    end
    
  end
end