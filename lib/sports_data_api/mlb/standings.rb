module SportsDataApi
  module Mlb
    class Standings
      attr_reader :id, :year, :al, :nl
      ##
      # Creates a new standings object
      def initialize(xml)
        @id = xml['season_id']
        @year = xml['season_year']
        create_leagues(xml.xpath('league'))
      end

      private
      def create_leagues(leagues_xml)
        leagues_xml.each do |league|
          league_hash = Hash.new
          instance_variable_set("@#{league['id'].downcase}", league_hash)
        end
      end
    end
  end
end
