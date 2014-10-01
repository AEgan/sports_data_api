module SportsDataApi
  module Nhl
    class Player
      attr_reader :stats, :id, :status, :full_name, :first_name, :last_name,
      :abbr_name, :height, :position, :primary_position, :jersey_number,
      :experience, :birth_place, :birthdate, :draft_round, :draft_pick, :weight

      def initialize(xml)
        if xml.is_a? Nokogiri::XML::Element
          # the commented out code below is from nba. I'm not sure what
          # it does at the moment, guess I should look this up. Metaprogramming
          # confuses me

          # player_ivar = self.instance_variable_set("@#{xml.name}", {})
          # self.class.class_eval { attr_reader :"#{xml.name}" }
          # xml.attributes.each do | attr_name, attr_value|
          #   player_ivar[attr_name.to_sym] = attr_value.value
          # end

          # We just don't have statistics in th xml so this is commented out
          # until I find it for nhl

          # stats_xml = xml.xpath('statistics')
          # if stats_xml.is_a? Nokogiri::XML::NodeSet and stats_xml.count > 0
          #   @stats = SportsDataApi::Stats.new(stats_xml.first)
          # end
          @id = xml['id']
          @status = xml['status']
          @full_name = xml['full_name']
          @first_name = xml['first_name']
          @last_name = xml['last_name']
          @abbr_name = xml['abbr_name']
          @height = xml['height']
          @weight = xml['weight']
          @position = xml['position']
          @primary_position = xml['primary_position']
          @jersey_number = xml['jersey_number']
          @experience = xml['experience']
          @birth_place = xml['birth_place']
          @birthdate = xml['birthdate']
          draft = xml.xpath('draft').first
          unless draft.nil?
            @draft_round = draft['round']
            @draft_pick = draft['pick']
          end
        end
      end
    end
  end
end
