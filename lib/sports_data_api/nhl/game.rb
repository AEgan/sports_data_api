module SportsDataApi
  module Nhl
    class Game
      attr_reader :id, :scheduled, :home, :home_team, :away,
        :away_team, :status, :venue, :broadcast, :year, :season,
        :date, :quarter, :clock

      def initialize(args={})
        xml = args.fetch(:xml)
        @year = args[:year] ? args[:year].to_i : nil
        @season = args[:season] ? args[:season].to_sym : nil
        @date = args[:date]

        xml = xml.first if xml.is_a? Nokogiri::XML::NodeSet
        if xml.is_a? Nokogiri::XML::Element
          @id = xml['id']
          @scheduled = Time.parse xml['scheduled']
          @home = xml['home_team']
          @away = xml['away_team']
          @status = xml['status']

          @home_team = Team.new(xml.xpath('home').first)
          @away_team = Team.new(xml.xpath('away').first)
          @venue = Venue.new(xml.xpath('venue'))
          @broadcast = Broadcast.new(xml.xpath('broadcast'))
        end
      end
    end
  end
end
