module Detour
  class TextFilter < Filter

    def replace(&block)
      @content = gsub_urls(content) do |url| 
        yield(Detour::URI.parse(url)).to_s
      end
    end

    def auto_link(options = {}); end
  end
end