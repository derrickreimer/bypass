module Bypass
  class TextFilter < Filter

    def replace(&block)
      @content = gsub_urls(content) do |url| 
        yield(Bypass::URI.parse(url)).to_s
      end
    end

    def auto_link(options = {}); end
  end
end