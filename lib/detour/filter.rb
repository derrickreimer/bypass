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
    
    # Public: Iterates over each anchor tag and yields it to a block. The URL
    # is replaced by the return value of the yielded block.
    #
    # block - A block that returns the value that should replace the given URL.
    #
    # Returns self.
    def replace_hrefs(&block)
      parsed_text.traverse do |node|
        if node.name == "a"
          node.set_attribute("href", yield(node.get_attribute("href")))
        end
      end
      
      self.text = parsed_text.to_s
      self
    end
    
    # Public: Iterates over each plain-text URL and yields it to a block. 
    # The URL is replaced by the return value of the yielded block. 
    # This method skips over links that are contained inside anchor tags, 
    # assuming that those URLs should be user-readable.
    #
    # block - A block that returns the value that should replace the given URL.
    #
    # Returns self.
    def replace_plain_text_urls(&block)
      parsed_text.traverse do |node|
        if node.name == "text"
          unless node.path.split("/").include?("a")
            text = node.text
            gsub_text_urls!(text) { |url| yield(url) }
            node.replace(Nokogiri::HTML::DocumentFragment.parse(text))
          end
        end
      end
      
      self.text = parsed_text.to_s
      self
    end
    
    # Public: Iterates over every linkable URL, both plain-text and in
    # the href attribute of anchor tags, and yields it to a block. The URL
    # is replaced by the return value of the yielded block. This method
    # skips over links that are contained inside anchor tags, assuming that
    # those URLs should be user-readable.
    #
    # block - A block that returns the value that should replace the given URL.
    #
    # Returns self.
    def replace(&block)
      replace_plain_text_urls(&block).replace_hrefs(&block)
    end
    
    # Public: Replaces each plain-text URL with an anchor tag.
    #
    # block - A block that returns the value that should replace the given URL.
    #
    # Returns self.
    def auto_link(options = {})
      replace_plain_text_urls { |url| anchor_tag(url, url, options) }
      self
    end
    
    # Public: Builds an HTML anchor tag.
    #
    # text    - The String inner tag content.
    # href    - The String URL href.
    # options - A Hash of additional HTML attributes.
    #
    # Returns a String.
    def anchor_tag(text, href, options = {})
      attributes = []
      disallowed = [:text, :href, "text", "href"]
      options = options.reject { |k, v| disallowed.include?(k) }
      options.each { |k, v| attributes << " #{k}=\"#{v}\"" }
      "<a href=\"#{href}\"#{attributes.join(' ')}>#{text}</a>"
    end
    
    def to_s
      text
    end
  
  private
  
    def gsub_text_urls!(text, &block)
      text.gsub!(URL_PATTERN) do |match|
        yield(match.to_s)
      end
    end
    
    def parsed_text
      @parsed_text ||= Nokogiri::HTML::DocumentFragment.parse(text)
    end
  end
end