require "addressable/uri"

module Bypass
  class URI < Addressable::URI
    def append_to_query_values(params = {})
      new_query_values = [].tap do |pairs|
        params.each do |key, value|
          pairs << "#{key}=#{value}"
        end
      end.join('&')

      if self.query.nil?
        self.query = "#{new_query_values}"
      else
        self.query += "&#{new_query_values}"
      end
    end
  end
end