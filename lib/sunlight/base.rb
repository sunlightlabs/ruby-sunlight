module Sunlight

  # Houses general methods to work with the Sunlight and Google Maps APIs
  class Base

    API_URL = "http://services.sunlightlabs.com/api/"
    API_FORMAT = "json"
    @@api_key = ''
    
    def self.api_key
     @@api_key
    end

    def self.api_key=(key)
     @@api_key = key
    end

    # Constructs a Sunlight API-friendly URL
    def self.construct_url(api_method, params)
      if api_key == nil or api_key == ''
        raise "Failed to provide Sunlight API Key"
      else
        "#{API_URL}#{api_method}.#{API_FORMAT}?apikey=#{api_key}#{hash2get(params)}"
      end
    end

    # Converts a hash to a GET string
    def self.hash2get(h)

      get_string = ""

      h.each_pair do |key, value|
        get_string += "&#{key.to_s}=#{CGI::escape value.to_s}"
      end

      get_string

    end

    # Use the Net::HTTP and JSON libraries to make the API call
    #
    # Usage:
    #   Sunlight::Deprecated::District.get_json_data("http://someurl.com")    # returns Hash of data or nil
    def self.get_json_data(url)

      response = Net::HTTP.get_response(URI.parse(url))
      if response.class == Net::HTTPOK
        result = JSON.parse(response.body)
      else
        nil
      end

    end

  end

end