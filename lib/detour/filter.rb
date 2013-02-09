require 'uri'

module Detour
  class Filter
    attr_reader :text, :options
    
    SCHEMES = %w(http https mailto)
    
    def initialize(text, options = {})
      @text = text
      @options = options
    end
    
    def links
      @links ||= URI.extract(text, SCHEMES)
    end
    
    def replace(&block)
      
    end
  end
end