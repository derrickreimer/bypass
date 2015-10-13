require "addressable/uri"

module Bypass
  class URI < Addressable::URI
    def append_to_query_values(params = {})
      pairs = params.keys.map { |key| "#{key}=#{Addressable::URI.encode(params[key])}" }
      pairs.unshift(query) if query
      self.query = pairs.join("&")
    end
  end
end