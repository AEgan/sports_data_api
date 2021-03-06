module SportsDataApi
  module Nba
    class Team
      attr_reader :id, :name, :market, :alias, :conference, :division,
                  :stats, :players, :points, :venue

      def initialize(xml, conference = nil, division = nil)
        xml = xml.first if xml.is_a? Nokogiri::XML::NodeSet
        if xml.is_a? Nokogiri::XML::Element
          @id = xml['id']
          @name = xml['name']
          @market = xml['market']
          @alias = xml['alias']
          @points = xml['points'] ? xml['points'].to_i : nil
          @conference = conference
          @division = division
          @players = xml.xpath("players/player").map do |player_xml|
            Player.new(player_xml)
          end
          venue_xml = xml.xpath('venue')
          unless venue_xml.empty?
            @venue = Venue.new(venue_xml)
          end
        end
      end

      ##
      # Compare the Team with another team
      def ==(other)
        # Must have an id to compare
        return false if self.id.nil?

        if other.is_a? SportsDataApi::Nba::Team
          return false if other.id.nil?
          self.id === other.id
        elsif other.is_a? Symbol
          self.id.to_sym === other
        else
          super(other)
        end
      end
    end
  end
end
