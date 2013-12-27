require "addressable/uri"

module Detour
  class URI < Addressable::URI
    def append_to_query_values(params = {})
      self.query_values = (query_values || {}).merge(params)
    end
  end
end