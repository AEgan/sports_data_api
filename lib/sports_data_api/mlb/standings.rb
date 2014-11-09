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
          league_hash = map_attributes_to_hash(league.attributes)
          league_hash[:divisions] = create_divisions(league.xpath('division'))
          instance_variable_set("@#{league['id'].downcase}", league_hash)
        end
      end

      def create_divisions(divisions_xml)
        divisions_hash = Hash.new
        divisions_xml.each do |division|
          division_hash = map_attributes_to_hash(division.attributes)
          division_hash[:teams] = create_teams(division.xpath('team'))
          divisions_hash[division['id'].downcase.to_sym] = division_hash
        end
        divisions_hash
      end

      def create_teams(teams_xml)
        Array.new
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
