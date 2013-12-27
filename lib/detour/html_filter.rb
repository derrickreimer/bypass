require "nokogiri"

module Detour
  class HTMLFilter < Filter

    def replace(&block)
      parsed_content.traverse do |node|
        if node.name == "a" && href = node.get_attribute("href")
          url = yield(Detour::URI.parse(href))
          node.set_attribute("href", url.to_s)
        end
      end
    end

    def auto_link(options = {})
      each_text_node do |node|
        text = gsub_urls(node.text.to_s) do |url| 
          build_anchor_tag(url, url, options)
        end
        node.replace(parse_html_fragment(text))
      end
    end

    def build_anchor_tag(text, href, options = {})
      attributes = []
      options.each { |k, v| attributes << " #{k}=\"#{v}\"" }
      "<a href=\"#{href}\"#{attributes.join(' ')}>#{text}</a>"
    end

    def content
      parsed_content.to_s
    end

  private

    def each_text_node(&block)
      parsed_content.traverse do |node|
        if node.name == "text"
          unless node.path.split("/").include?("a")
            yield(node)
          end
        end
      end
    end

    def parsed_content
      @parsed_content ||= parse_html_fragment(@content)
    end

    def parse_html_fragment(html)
      Nokogiri::HTML::DocumentFragment.parse(html)
    end
  end
end