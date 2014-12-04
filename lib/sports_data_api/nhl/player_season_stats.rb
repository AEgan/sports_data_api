module SportsDataApi
  module Nhl
    class PlayerSeasonStats
      attr_reader :id, :player, :seasons
      ##
      # Creates a new PlayerSeasonStats object
      def initialize(xml)
        @player = SportsDataApi::Nhl::Player.new(xml)
        @id = xml['id']
        create_seasons(xml.xpath('seasons/season'))
      end

      private
      # creates an array of seasons
      def create_seasons(seasons_xml)
        @seasons = Array.new
        seasons_xml.each do |season|
          season_hash = map_attributes_to_hash(season.attributes)
          season_hash[:teams] = create_teams(season.xpath('team'))
          @seasons << season_hash
        end
        @seasons
      end

      # creates a teams array, multiple teams if player is traded
      def create_teams(teams_xml)
        teams = Array.new
        teams_xml.each do |team|
          team_hash = map_attributes_to_hash(team)
          team_hash[:statistics] = create_statistics(team.xpath('statistics').first)
          team_hash[:average] = map_attributes_to_hash(team.xpath('statistics/average').first.attributes)
          team_hash[:time_on_ice] = create_time_on_ice(team.xpath('time_on_ice').first)
          goaltending_xml = team.xpath('goaltending')
          unless goaltending_xml.empty?
            team_hash[:goaltending] = create_goaltending(goaltending_xml)
          end
          teams << team_hash
        end
        teams
      end

      # creates the time on ice hash
      def create_time_on_ice(toi_hash)
        total = toi_hash.xpath('total').first
        average = toi_hash.xpath('average').first
        {
          shifts: total['shifts'].to_i,
          total: total['total'],
          shifts_pg: average['shifts'].to_f,
          toi_pg: average['total']
        }
      end

      # creates the statistics hash
      def create_statistics(statistics_xml)
        statistics_hash = Hash.new
        total_xml = statistics_xml.xpath('total').first
        statistics_hash[:total] = map_attributes_to_hash(total_xml.attributes)
        statistics_hash[:powerplay] = map_attributes_to_hash(total_xml.xpath('powerplay').first.attributes)
        statistics_hash[:shorthanded] = map_attributes_to_hash(total_xml.xpath('shorthanded').first.attributes)
        statistics_hash[:even_strength] = map_attributes_to_hash(total_xml.xpath('evenstrength').first.attributes)
        statistics_hash[:penalty_shots] = map_attributes_to_hash(total_xml.xpath('penalty').first.attributes)
        statistics_hash[:shootout] = map_attributes_to_hash(total_xml.xpath('shootout').first.attributes)
        statistics_hash
      end

      # creates a goaltending hash
      def create_goaltending(goaltending_xml)
        goaltending_hash = Hash.new
        total_xml = goaltending_xml.xpath('total').first
        goaltending_hash[:total] = map_attributes_to_hash(total_xml.attributes)
        goaltending_hash[:powerplay] = map_attributes_to_hash(total_xml.xpath('powerplay').first.attributes)
        goaltending_hash[:shorthanded] = map_attributes_to_hash(total_xml.xpath('shorthanded').first.attributes)
        goaltending_hash[:even_strength] = map_attributes_to_hash(total_xml.xpath('evenstrength').first.attributes)
        goaltending_hash[:penalty_shots] = map_attributes_to_hash(total_xml.xpath('penalty').first.attributes)
        goaltending_hash[:shootout] = map_attributes_to_hash(total_xml.xpath('shootout').first.attributes)
        goaltending_hash[:average] = map_attributes_to_hash(goaltending_xml.xpath('average').first.attributes)
        goaltending_hash
      end

      # maps attributes to a hash and converts
      def map_attributes_to_hash(attributes)
        attr_hash = Hash.new
        float_pattern = /([0-9]\.)+/
        word_pattern = /([A-Za-z]|:)/
        attributes.each do |k, v|
          value_string = v.to_s
          if float_pattern.match(value_string)
            attr_hash[k.to_sym] = value_string.to_f
          elsif word_pattern.match(value_string)
            attr_hash[k.to_sym] = value_string
          else
            attr_hash[k.to_sym] = value_string.to_i
          end
        end
        attr_hash
      end

    end
  end
end
