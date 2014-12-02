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
          conference_hash = map_attributes_to_hash(conference.attributes)
          conference_hash[:divisions] = create_divisions(conference.xpath('division'))
          instance_variable_set("@#{conference['alias'].downcase}", conference_hash)
        end
      end

      # creates a hash for all divisions
      def create_divisions(divisions_xml)
        divisions_hash = Hash.new
        divisions_xml.each do |division|
          division_hash = map_attributes_to_hash(division.attributes)
          division_hash[:teams] = create_teams(division.xpath('team'))
          divisions_hash[division['name'].downcase.to_sym] = division_hash
        end
        divisions_hash
      end

      # creates the teams array
      def create_teams(teams_xml)
        teams_array = Array.new
        teams_array
      end

      # maps attributes to a hash
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
