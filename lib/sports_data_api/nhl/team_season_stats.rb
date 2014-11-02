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
        total_xml = team_xml.xpath('team_records/overall/statistics/total').first
        powerplay_xml = total_xml.xpath('powerplay').first
        shorthanded_xml = total_xml.xpath('shorthanded').first
        even_strength_xml = total_xml.xpath('evenstrength').first
        penalty_shots_xml = total_xml.xpath('penalty').first
        team_hash[:total] = create_total_stats(total_xml, powerplay_xml, shorthanded_xml, even_strength_xml, penalty_shots_xml)
        team_hash[:goaltending] = Hash.new
        team_hash[:shootouts] = map_attributes_to_hash(team_xml.xpath('team_records/overall/shootout').first)
        team_hash
      end

      ##
      # Creates the hash for a team's total stats
      def create_total_stats(total_xml, powerplay_xml, shorthanded_xml, even_strength_xml, penalty_shots_xml)
        total_hash = map_attributes_to_hash(total_xml.attributes)
        total_hash[:powerplay] = map_attributes_to_hash(powerplay_xml)
        total_hash[:shorthanded] = map_attributes_to_hash(shorthanded_xml)
        total_hash[:even_strength] = map_attributes_to_hash(even_strength_xml)
        total_hash[:penalty_shots] = map_attributes_to_hash(penalty_shots_xml)
        total_hash
      end

      def map_attributes_to_hash(attributes)
        attr_hash = Hash.new
        float_pattern = /([0-9]\.)+/
        attributes.each do |k, v|
          if float_pattern.match("#{v}")
            attr_hash[k.to_sym] = "#{v}".to_f
          else
            attr_hash[k.to_sym] = "#{v}".to_i
          end
        end
        attr_hash
      end


    end
  end
end
