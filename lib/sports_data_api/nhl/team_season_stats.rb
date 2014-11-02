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
        team_hash[:total] = create_total_stats(team_xml.xpath('team_records/overall/statistics/total').first)
        team_hash[:goaltending] = Hash.new
        team_hash
      end

      ##
      # Creates the hash for a team's total stats
      def create_total_stats(total_xml)
        total_hash = Hash.new
        float_pattern = /([0-9]\.)+/
        total_xml.attributes.each do |k, v|
          if float_pattern.match(v.value)
            total_hash[k.to_sym] = v.value.to_f
          else
            total_hash[k.to_sym] = v.value.to_i
          end
        end
        total_hash
      end
    end
  end
end
