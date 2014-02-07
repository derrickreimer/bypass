module Bypass
  class TextFilter < Filter

    def replace(&block)
      @content = gsub_urls(content) do |url|
        if parsed_url = parse_uri(url)
          yield(parsed_url).to_s
        end
      end
    end

    def auto_link(options = {}); end
  end
end