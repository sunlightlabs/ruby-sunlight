module Sunlight
  
  class Filing < Base
    attr_accessor :filing_id, :filing_period, :filing_date, :filing_amount,
                  :filing_year, :filing_type, :filing_pdf, :client_senate_id,
                  :client_name, :client_country, :client_state,
                  :client_ppb_country, :client_ppb_state, :client_description,
                  :client_contact_firstname, :client_contact_middlename,
                  :client_contact_lastname, :client_contact_suffix,
                  :registrant_senate_id, :registrant_name, :registrant_address,
                  :registrant_description, :registrant_country,
                  :registrant_ppb_country, :lobbyists, :issues

    # Takes in a hash where the keys are strings (the format passed in by the JSON parser)
    #
    def initialize(params)
      params.each do |key, value|    
        instance_variable_set("@#{key}", value) if Filing.instance_methods.map { |m| m.to_sym }.include? key.to_sym
      end
    end

    #
    # Get a filing based on filing ID.
    #
    # See the API documentation:
    #
    # http://wiki.sunlightlabs.com/index.php/Lobbyists.getFiling
    #
    # Returns:
    #
    # A Filing and corresponding Lobbyists and Issues matching
    # the given ID, or nil if one wasn't found.
    #
    # Usage:
    #
    #   filing = Sunlight::Filing.get("29D4D19E-CB7D-46D2-99F0-27FF15901A4C")
    #   filing.issues.each { |issue| ... }
    #   filing.lobbyists.each { |lobbyist| ... }
    #
    def self.get(id)
      url = construct_url("lobbyists.getFiling", :id => id)

      if (response = get_json_data(url))
        if (f = response["response"]["filing"])
          filing = Filing.new(f)
          filing.lobbyists = filing.lobbyists.map do |lobbyist|
            Lobbyist.new(lobbyist["lobbyist"])
          end
          filing.issues = filing.issues.map do |issue|
            Issue.new(issue["issue"])
          end
          filing
        else
          nil
        end
      else
        nil
      end
    end

    #
    # Search the filing database. At least one of client_name or
    # registrant_name must be provided, along with an optional year.
    # Note that year is recommended, as the full data set dating back
    # to 1999 may be enormous.
    #
    # See the API documentation:
    #
    # http://wiki.sunlightlabs.com/index.php/Lobbyists.getFilingList
    #
    # Returns:
    #
    # An array of Filing objects that match the conditions
    #
    # Usage:
    #
    #   filings = Filing.all_where(:client_name => "SUNLIGHT FOUNDATION")
    #   filings.each do |filing|
    #     ...
    #     filing.issues.each { |issue| ... }
    #     filing.lobbyists.each { |issue| ... }    
    #   end
    #
    def self.all_where(params)
      if params[:client_name].nil? and params[:registrant_name].nil?
        nil
      else
        url = construct_url("lobbyists.getFilingList", params)
        
        if (response = get_json_data(url))
          filings = []
          
          response["response"]["filings"].each do |result|
            filing = Filing.new(result["filing"])

            filing.lobbyists = filing.lobbyists.map do |lobbyist|
              Lobbyist.new(lobbyist["lobbyist"])
            end
            filing.issues = filing.issues.map do |issue|
              Issue.new(issue["issue"])
            end

            filings << filing
          end
          
          if filings.empty?
            nil
          else
            filings
          end
        else
          nil
        end
      end # if params
    end # def self.all_where
    
  end # class Filing

end # module Sunlight