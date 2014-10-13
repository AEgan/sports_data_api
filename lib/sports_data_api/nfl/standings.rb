module SportsDataApi
  module Nfl
    class Standings
      attr_reader :season, :type, :nfc, :afc
      def initialize(xml)
        conferences = xml.xpath('conference')
        @season = xml[:season].to_i
        @type = xml[:type]
        @afc = create_conference(conferences.first)
        @nfc = create_conference(conferences.last)
      end

      private
      def create_conference(conference_xml)
        conference = Hash.new
        conference[:name] = conference_xml[:name]
        conference[:divisions] = Array.new
        conference_xml.xpath('division').each do |division|
          conference[:divisions] << create_division(division)
        end
        conference
      end

      def create_division(division_xml)
        division = Hash.new
        division[:name] = division_xml[:name]
        division[:id] = division_xml[:id]
        division[:teams] = Array.new
        division_xml.xpath('team').each do |team|
          division[:teams] << create_team(team)
        end
        division
      end


      def create_team(team_xml)
        team = Hash.new
        team[:id] = team_xml[:id]
        team[:name] = team_xml[:name]
        team[:market] = team_xml[:market]
        %w(overall in_conference non_conference in_division grass turf scored_first decided_by_7_points leading_at_half last_5 ).each do |stat|
          team[stat.to_sym] = record_stats(team_xml.xpath(stat).first)
        end
        team[:points] = key_value_integer_map(team_xml.xpath('points').first)
        team[:streak] = streak_hash(team_xml.xpath('streak').first)
        team
      end

      def record_stats(record_xml)
        record = Hash.new
        record[:wins] = record_xml[:wins].to_i
        record[:losses] = record_xml[:losses].to_i
        record[:ties] = record_xml[:ties].to_i
        record[:winning_percentage] = record_xml[:wpct].to_f unless record_xml[:wpct].nil?
        record
      end

      def key_value_integer_map(stats_xml)
        mapped_values = Hash.new
        stats_xml.attributes.each { |k, v| mapped_values[k.to_sym] = "#{v}".to_i }
        mapped_values
      end

      def streak_hash(streak_xml)
        { type: streak_xml[:type], length: streak_xml[:value].to_i }
      end
    end
  end
end
