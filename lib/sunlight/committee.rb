module Sunlight
  module Deprecated

    class Committee < Base

      attr_accessor :name, :id, :chamber, :subcommittees, :members

      def initialize(params)
        params.each do |key, value|

          case key

          when 'subcommittees'
            self.subcommittees = []
            value.each do |subcommittee|
              self.subcommittees << Sunlight::Deprecated::Committee.new(subcommittee["committee"])
            end
            
          when 'members'
            self.members = []
            value.each do |legislator|
              self.members << Sunlight::Deprecated::Legislator.new(legislator["legislator"])
            end
      
          else
            instance_variable_set("@#{key}", value) if Committee.instance_methods.map { |m| m.to_sym }.include? key.to_sym
          end
        end
      end
      
      def load_members
        self.members = Sunlight::Deprecated::Committee.get(self.id).members
      end
      
      # 
      # Usage:
      #   Sunlight::Deprecated::Committee.get("JSPR")     # returns a Committee
      #
      def self.get(id)

        url = construct_url("committees.get", {:id => id})
        
        if (result = get_json_data(url))
          committee = Committee.new(result["response"]["committee"])
        else
          nil # appropriate params not found
        end

      end
      
      #
      # Usage:
      #   Sunlight::Deprecated::Committee.all_for_chamber("Senate") # or "House" or "Joint"
      #
      # Returns:
      #
      # An array of Committees in that chamber of Congress
      #
      def self.all_for_chamber(chamber)
        
        url = construct_url("committees.getList", {:chamber=> chamber})
        
        if (result = get_json_data(url))
          committees = []
          result["response"]["committees"].each do |committee|
            committees << Committee.new(committee["committee"])
          end
        else
          nil # appropriate params not found
        end
        
        committees
        
      end

    end
  end
end