module SportsDataApi
  module Nhl
    class TeamSeasonStats
      attr_reader :year, :season, :team, :opponents
      ##
      # Creates a new nhl TeamSeasonStats object
      def initialize(xml)
        @year = xml['year']
        @season = xml['type']
        @team = create_team(xml.xpath('team').first)
        @opponents = create_team_group(xml.xpath('team/team_records/opponents').first)
      end

      # private helper methods
      private
      ##
      # Creates the team hash for all team information
      def create_team(team_xml)
        team_hash = create_team_group(team_xml.xpath('team_records/overall').first)
        team_xml.attributes.each { |k,v| team_hash[k.to_sym] = v.value }
        team_hash
      end

      ##
      # Creats a hash to map statistics for a team or opponent
      def create_team_group(group_xml)
        group_hash = Hash.new
        group_hash[:statistics] = create_stats_group(group_xml.xpath('statistics').first)
        group_hash[:goaltending] = create_stats_group(group_xml.xpath('goaltending').first)
        group_hash[:shootouts] = map_attributes_to_hash(group_xml.xpath('shootout').first)
        group_hash
      end

      ##
      # Splits the stats xml into its nodes and creates a hash out of them
      def create_stats_group(stats_xml)
        total_xml = stats_xml.xpath('total').first
        powerplay_xml = total_xml.xpath('powerplay').first
        shorthanded_xml = total_xml.xpath('shorthanded').first
        even_strength_xml = total_xml.xpath('evenstrength').first
        penalty_shots_xml = total_xml.xpath('penalty').first
        create_stats_hash(total_xml, powerplay_xml, shorthanded_xml, even_strength_xml, penalty_shots_xml)
      end

      ##
      # Creates the hash for a team's total stats
      def create_stats_hash(total_xml, powerplay_xml, shorthanded_xml, even_strength_xml, penalty_shots_xml)
        statistics_hash = Hash.new
        statistics_hash[:total] = map_attributes_to_hash(total_xml.attributes)
        statistics_hash[:powerplay] = map_attributes_to_hash(powerplay_xml)
        statistics_hash[:shorthanded] = map_attributes_to_hash(shorthanded_xml)
        statistics_hash[:even_strength] = map_attributes_to_hash(even_strength_xml)
        statistics_hash[:penalty_shots] = map_attributes_to_hash(penalty_shots_xml)
        statistics_hash
      end

      ##
      # Maps the attributes and values of a node into a hash, converting
      # the values into floats or integers
      def map_attributes_to_hash(attributes)
        attr_hash = Hash.new
        float_pattern = /([0-9]\.)+/
        attributes.each do |k, v|
          value_string = v.to_s
          if float_pattern.match(value_string)
            attr_hash[k.to_sym] = value_string.to_f
          else
            attr_hash[k.to_sym] = value_string.to_i
          end
        end
        attr_hash
      end

    end
  end
end
