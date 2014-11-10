module SportsDataApi
  module Mlb
    class TeamSeasonStats
      attr_reader :id, :year
      ##
      # creates a new TeamSeasonStats object
      def initialize(xml)
        xml = xml.first if xml.is_a? Nokogiri::XML::NodeSet
        @id = xml['season_id']
        @year = xml['season_year']
        @team_names = Array.new
        create_teams(xml.xpath('team'))
      end

      def method_missing(m, *args, &block)
        if @team_names.include?(m.to_s)
          return instance_variable_get("@#{m.to_s}")
        else
          super
        end
      end

      private
      def create_teams(teams_xml)
        teams_xml.each do |t|
          team_name_str = t['name'].downcase.sub(' ', '_')
          @team_names << team_name_str
          team_hash = Hash.new
          t.attributes.each { |k, v| team_hash[k.to_sym] = v.value }
          team_hash[:hitting] = create_hitting(t.xpath('hitting').first)
          team_hash[:pitching] = create_pitching(t.xpath('pitching').first)
          team_hash[:fielding] = map_attributes_to_hash(t.xpath('fielding').first.attributes)
          self.instance_variable_set("@#{team_name_str}", team_hash)
        end
      end

      ##
      # Creates the hitting hash
      def create_hitting(hitting_xml)
        hitting = map_attributes_to_hash(hitting_xml.attributes)
        add_common_attributes(hitting, hitting_xml)
        hitting
      end

      ##
      # Creates the pitching hash
      def create_pitching(pitching_xml)
        pitching = map_attributes_to_hash(pitching_xml.attributes)
        pitching[:games] = map_attributes_to_hash(pitching_xml.xpath('games').first)
        add_common_attributes(pitching, pitching_xml)
        pitching
      end

      def add_common_attributes(stats_hash, stats_xml)
        stats_hash[:onbase] = map_attributes_to_hash(stats_xml.xpath('onbase').first)
        stats_hash[:runs] = map_attributes_to_hash(stats_xml.xpath('runs').first)
        stats_hash[:outcome] = map_attributes_to_hash(stats_xml.xpath('outcome').first)
        stats_hash[:outs] = map_attributes_to_hash(stats_xml.xpath('outs').first)
        stats_hash[:steal] = map_attributes_to_hash(stats_xml.xpath('steal').first)
      end

       ##
      # Maps the attributes and values of a node into a hash, converting
      # the values into floats or integers
      def map_attributes_to_hash(attributes)
        attr_hash = Hash.new
        float_pattern = /([0-9]?\.[0-9]+)/
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
