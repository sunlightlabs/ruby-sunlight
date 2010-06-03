module Sunlight

  class Lobbyist < Base
    attr_accessor :firstname, :middlename, :lastname, :suffix,
                  :official_position, :filings, :fuzzy_score
  
    # Takes in a hash where the keys are strings (the format passed in by the JSON parser)
    #
    def initialize(params)
      params.each do |key, value|    
        instance_variable_set("@#{key}", value) if Lobbyist.instance_methods.map { |m| m.to_sym }.include? key.to_sym
      end
    end

    #
    # Fuzzy name searching of lobbyists. Returns possible matching Lobbyists
    # along with a confidence score. Confidence scores below 0.8
    # mean the lobbyist should not be used.
    #
    # See the API documentation:
    #
    # http://wiki.sunlightlabs.com/index.php/Lobbyists.search
    #
    # Returns:
    #
    # An array of Lobbyists, with the fuzzy_score set as an attribute
    #
    # Usage:
    #
    #   lobbyists = Lobbyist.search("Nisha Thompsen")
    #   lobbyists = Lobbyist.search("Michael Klein", 0.95, 2007)
    #
    def self.search_by_name(name, threshold=0.9, year=Time.now.year)

      url = construct_url("lobbyists.search", :name => name, :threshold => threshold, :year => year)
      
      if (results = get_json_data(url))
        lobbyists = []
        results["response"]["results"].each do |result|
          if result
            lobbyist = Lobbyist.new(result["result"]["lobbyist"])
            fuzzy_score = result["result"]["score"]

            if threshold.to_f < fuzzy_score.to_f
              lobbyist.fuzzy_score = fuzzy_score.to_f
              lobbyists << lobbyist
            end
          end
        end

        if lobbyists.empty?
          nil
        else
          lobbyists
        end
      
      else
        nil
      end
    end # def self.search
  end # class Lobbyist

end