module SportsDataApi
  module Nhl
    class TeamSeasonStats
      attr_reader :year, :season, :team
      ##
      # Creates a new nhl TeamSeasonStats object
      def initialize(xml)
        @year = xml['year']
        @season = xml['type']
        @team = create_team(xml.xpath('team').first)
      end

      private
      ##
      # Creates the team hash for all team information
      def create_team(team_xml)
        team_hash = Hash.new
        team_xml.attributes.each { |k,v| team_hash[k.to_sym] = v.value }
        team_hash[:total] = Hash.new
        team_hash[:goaltending] = Hash.new
        team_hash
      end
    end
  end
end
