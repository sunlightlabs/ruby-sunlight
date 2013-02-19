require 'time'

module Sunlight
  module Deprecated

    class Legislator < Base


      attr_accessor :title, :firstname, :middlename, :lastname, :name_suffix, :nickname,
                    :party, :state, :district, :in_office, :gender, :phone, :fax, :website, :webform,
                    :congress_office, :bioguide_id, :fec_id,
                    :govtrack_id, :crp_id, :twitter_id, :youtube_url, :facebook_id,
                    :senate_class, :birthdate, :fuzzy_score

      # Takes in a hash where the keys are strings (the format passed in by the JSON parser)
      #
      def initialize(params)
        params.each do |key, value|
          value = Time.parse(value) if key == "birthdate" && value && value.size > 0
          instance_variable_set("@#{key}", value) if Legislator.instance_methods.map { |m| m.to_sym }.include? key.to_sym
        end
      end
      
      # Convenience method for getting out the youtube_id from the youtube_url
      def youtube_id
        /http:\/\/(?:www\.)?youtube\.com\/(?:user\/)?(.*?)\/?$/.match(youtube_url)[1] unless youtube_url.nil?
      end
      
      # Get the committees the Legislator sits on
      #
      # Returns:
      #
      # An array of Committee objects, each possibly
      # having its own subarray of subcommittees
      def committees
        url = Sunlight::Base.construct_url("committees.allForLegislator", {:bioguide_id => self.bioguide_id})

         if (result = Sunlight::Base.get_json_data(url))
           committees = []
           result["response"]["committees"].each do |committee|
             committees << Sunlight::Deprecated::Committee.new(committee["committee"])
           end
         else
           nil # appropriate params not found
         end
         committees
      end


      #
      # Useful for getting the exact Legislators for a given district.
      #
      # Returns:
      #
      # A Hash of the three Members of Congress for a given District: Two
      # Senators and one Representative.
      #
      # You can pass in lat/long or address. The district will be
      # determined for you:
      #
      #   officials = Legislator.all_for(:latitude => 33.876145, :longitude => -84.453789)
      #   senior = officials[:senior_senator]
      #   junior = officials[:junior_senator]
      #   rep = officials[:representative]
      #
      def self.all_for(params)

        if (params[:latitude] and params[:longitude])
          Legislator.all_in_district(District.get(:latitude => params[:latitude], :longitude => params[:longitude]))
        else
          nil # appropriate params not found
        end

      end


      #
      # A helper method for all_for. Use that instead, unless you 
      # already have the district object, then use this.
      #
      # Usage:
      #
      #   officials = Sunlight::Deprecated::Legislator.all_in_district(District.new("NJ", "7"))
      #
      def self.all_in_district(district)

        senior_senator = Legislator.all_where(:state => district.state, :district => "Senior Seat").first
        junior_senator = Legislator.all_where(:state => district.state, :district => "Junior Seat").first
        representative = Legislator.all_where(:state => district.state, :district => district.number).first

        {:senior_senator => senior_senator, :junior_senator => junior_senator, :representative => representative}

      end


      #
      # A more general, open-ended search on Legislators than #all_for.
      # See the Sunlight API for list of conditions and values:
      #
      # http://services.sunlightlabs.com/api/docs/legislators/
      #
      # Returns:
      #
      # An array of Legislator objects that matches the conditions
      #
      # Usage:
      #
      #   johns = Sunlight::Deprecated::Legislator.all_where(:firstname => "John")
      #   floridians = Sunlight::Deprecated::Legislator.all_where(:state => "FL")
      #   dudes = Sunlight::Deprecated::Legislator.all_where(:gender => "M")
      #
      def self.all_where(params)

        url = construct_url("legislators.getList", params)

        if (result = get_json_data(url))

          legislators = []
          result["response"]["legislators"].each do |legislator|
            legislators << Legislator.new(legislator["legislator"])
          end

          legislators

        else  
          nil
        end # if response.class

      end
      
      #
      # When you only have a zipcode, use this.
      # It specifically accounts for the case where more than one Representative's district
      # is in a zip code.
      # 
      #
      # Returns:
      #
      # An array of Legislator objects
      #
      # Usage:
      #
      #   legislators = Sunlight::Deprecated::Legislator.all_in_zipcode(90210)
      #
      def self.all_in_zipcode(zipcode)

        url = construct_url("legislators.allForZip", {:zip => zipcode})
        
        if (result = get_json_data(url))

          legislators = []
          result["response"]["legislators"].each do |legislator|
            legislators << Legislator.new(legislator["legislator"])
          end

          legislators

        else  
          nil
        end # if response.class

      end # def self.all_in_zipcode
      
      
      # 
      # Fuzzy name searching. Returns possible matching Legislators 
      # along with a confidence score. Confidence scores below 0.8
      # mean the Legislator should not be used.
      #
      # The API documentation explains it best:
      # 
      # http://services.sunlightlabs.com/docs/congressapi/legislators.search/
      #
      # Returns:
      #
      # An array of Legislators, with the fuzzy_score set as an attribute
      #
      # Usage:
      #
      #   legislators = Sunlight::Deprecated::Legislator.search_by_name("Teddy Kennedey")
      #   legislators = Sunlight::Deprecated::Legislator.search_by_name("Johnny Kerry", 0.9)
      #
      def self.search_by_name(name, threshold='0.8')
        
        url = construct_url("legislators.search", {:name => name, :threshold => threshold})
        
        if (response = get_json_data(url))
          
          legislators = []
          response["response"]["results"].each do |result|
            if result
              legislator = Legislator.new(result["result"]["legislator"])
              fuzzy_score = result["result"]["score"]
              
              if threshold.to_f < fuzzy_score.to_f
                legislator.fuzzy_score = fuzzy_score.to_f
                legislators << legislator
              end
            end
          end
          
          if legislators.empty?
            nil
          else
            legislators 
          end
          
        else
          nil
        end
        
      end 
      
    end
  end
end