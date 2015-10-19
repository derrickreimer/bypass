require "addressable/uri"

module Bypass
  class URI < Addressable::URI
    def append_to_query_values(params = {})
      pairs = params.keys.map do |raw_key|
        key = self.class.encode(raw_key.to_s)
        val = self.class.encode(params[raw_key])
        [key, val].join("=")
      end

      pairs.unshift(query) if query
      self.query = pairs.join("&")
    end
  end
end
