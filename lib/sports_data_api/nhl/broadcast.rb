module SportsDataApi
  module Nhl
    class Broadcast
      attr_reader :network
      def initialize(xml)
        xml = xml.first if xml.is_a? Nokogiri::XML::NodeSet
        if xml.is_a? Nokogiri::XML::Element
          @network = xml['network']
        end
      end
    end
  end
end
