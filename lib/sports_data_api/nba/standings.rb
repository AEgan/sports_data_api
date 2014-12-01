module SportsDataApi
  module Nba
    class Standings
      attr_reader :year, :season
      # creates a new standings object
      def initialize(xml)
        xml = xml.first if xml.is_a? Nokogiri::XML::NodeSet
        @year = xml['year']
        @season = xml['type']
        create_conferences(xml.xpath('conference'))
      end

      # method missing for conferences and divisions
      def method_missing(meth, *args, &block)
        if self.instance_variables.include?("@#{meth}".to_sym)
          self.instance_variable_get("@#{meth}")
        else
          super
        end
      end

      private
      def create_conferences(conferences_xml)
        conferences_xml.each do |conference|
          instance_variable_set("@#{conference['alias'].downcase}", {})
        end
      end

    end
  end
end
