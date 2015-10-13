require "addressable/uri"

module Bypass
  class URI < Addressable::URI
    def append_to_query_values(params = {})
      pairs = params.keys.map { |key| "#{Addressable::URI.encode(key.to_s)}=#{Addressable::URI.encode(params[key])}" }
      pairs.unshift(query) if query
      self.query = pairs.join("&")
    end
  end
end