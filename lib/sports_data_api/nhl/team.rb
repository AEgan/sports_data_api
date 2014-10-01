module SportsDataApi
  module Nhl
    class Team
      attr_reader :id, :name, :alias, :conference, :division, :market

      def initialize(xml, conference = nil, division = nil)
        xml = xml.first if xml.is_a? Nokogiri::XML::NodeSet
        if xml.is_a? Nokogiri::XML::Element
          @id = xml['id']
          @name = xml['name']
          @alias = xml['alias']
          @market = xml['market']
          @conference = conference
          @division = division
        end
      end

      ##
      # Compare the Team with another team
      def ==(other)
        # Must have an id to compare
        return false if self.id.nil?

        if other.is_a? SportsDataApi::Nhl::Team
          return false if other.id.nil?
          self.id === other.id
        elsif other.is_a? Symbol
          self.id.to_sym === other
        else
          super(other)
        end
      end

      # gets the roster for the team
      def get_roster(version = SportsDataApi::Nhl::DEFAULT_VERSION)
        base_url = SportsDataApi::Nhl::BASE_URL % { access_level: SportsDataApi.access_level(SPORT), version: version }
        url = "/teams/#{@id}/profile.xml"
        response = SportsDataApi.generic_request("#{base_url}#{url}", SportsDataApi::Nhl::SPORT)
        xml = Nokogiri::XML(response.to_s).remove_namespaces!
        xml.xpath('team/players/player').map { |player| Player.new(player) }
      end
    end
  end
end
