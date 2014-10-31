module SportsDataApi
  module Nhl
    class Standings
      attr_reader :year, :type, :east, :west
      def initialize(xml)
        @year = xml['year']
        @type = xml['type']
        conferences = xml.xpath('conference')
        @west = create_conference(conferences.first)
        @east = create_conference(conferences.last)
      end

      private
      ##
      # creates a conference from the conference xml
      def create_conference(conference_xml)
        conf = Hash.new
        conf[:name] = conference_xml['name']
        conf[:alias] = conference_xml['alias']
        conf[:divisions] = Array.new
        conference_xml.xpath('division').each do |division_xml|
          division_hash = create_division(division_xml)
          conf[division_hash[:alias]] = division_hash
          conf[:divisions] << division_hash
        end
        conf
      end

      ##
      # creates a division from the division xml
      def create_division(division_xml)
        division = Hash.new
        division[:alias] = division_xml['alias']
        division[:name] = division_xml['name']
        teams = Array.new
        division_xml.xpath('team').each do |team_xml|
          teams << create_team(team_xml)
        end
        division[:teams] = teams
        division
      end

      ##
      # creates a team from the team xml
      def create_team(team_xml)
        team = Hash.new
        word_pattern = /[A-Za-z]/
        float_pattern = /([0-9]\.)+/
        # put team info in a hash, convert it to the correct data type
        team_xml.attributes.each do |k, v|
          if word_pattern.match(v.value)
            team[k.to_sym] = v.value
          elsif float_pattern.match(v.value)
            team[k.to_sym] = v.value.to_f
          else
            team[k.to_sym] = v.value.to_i
          end
        end
        streak_xml = team_xml.xpath('streak').first
        word = streak_xml.xpath('win').empty? ? 'loss' : 'win'
        team[:streak] = create_streak(word, streak_xml.xpath(word).first)
        records = Hash.new
        %w(atlantic central conference division home last_10 last_10_home last_10_road metropolitan pacific road).each do |cat|
          records[cat.to_sym] = create_record(team_xml.xpath("records/#{cat}").first)
        end
        team[:records] = records
        team
      end

      ##
      # creates a hash for a streak
      def create_streak(type, streak_xml)
        {
          type: type,
          length: streak_xml['length'].to_i
        }
      end

      ##
      # creates a record hash
      def create_record(record_xml)
        {
          wins: record_xml['wins'].to_i,
          losses: record_xml['losses'].to_i,
          overtime_losses: record_xml['overtime_losses'].to_i,
          winning_percentage: record_xml['win_pct'].to_f
        }
      end

    end
  end
end
