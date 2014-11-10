module SportsDataApi
  module Mlb

    class Exception < ::Exception
    end

    DIR = File.join(File.dirname(__FILE__), 'mlb')
    BASE_URL = 'http://api.sportsdatallc.org/mlb-%{access_level}%{version}'
    DEFAULT_VERSION = 4
    SPORT = :mlb

    autoload :Team, File.join(DIR, 'team')
    autoload :Teams, File.join(DIR, 'teams')
    autoload :Player, File.join(DIR, 'player')
    autoload :Players, File.join(DIR, 'players')
    autoload :Game, File.join(DIR, 'game')
    autoload :Games, File.join(DIR, 'games')
    autoload :Season, File.join(DIR, 'season')
    autoload :Broadcast, File.join(DIR, 'broadcast')
    autoload :GameStat, File.join(DIR,'game_stat')
    autoload :GameStats, File.join(DIR, 'game_stats')
    autoload :Boxscore, File.join(DIR, 'boxscore')
    autoload :Venue, File.join(DIR, 'venue')
    autoload :Venues, File.join(DIR, 'venues')
    autoload :TeamSeasonStats, File.join(DIR, 'team_season_stats')
    autoload :PlayerSeasonStats, File.join(DIR, 'player_season_stats')
    autoload :Standings, File.join(DIR, 'standings')

    ##
    # Fetches all NBA teams
    def self.teams(year=Date.today.year, version = DEFAULT_VERSION)
      response = self.response_xml(version, "/teams/#{year}.xml")
      return Teams.new(response.xpath('/teams'))
    end

    ##
    # Fetches MLB season schedule for a given year and season
    def self.schedule(year=Date.today.year, version = DEFAULT_VERSION)
      response = self.response_xml(version, "/schedule/#{year}.xml")
      return Season.new(response.xpath("calendars"))
    end

    ##
    # Fetches MLB daily schedule for a given date
    def self.daily(year, month, day, version = DEFAULT_VERSION)
      response = self.response_xml(version, "/daily/schedule/#{year}/#{month}/#{day}.xml")
      return Games.new(response.xpath("calendars"))
    end

    ##
    # Fetches MLB venues
    def self.venues(version = DEFAULT_VERSION)
      response = self.response_xml(version, "/venues/venues.xml")
      return Venues.new(response.xpath("venues"))
    end

    ##
    # Fetch MLB game stats
    def self.game_statistics(event_id, version = DEFAULT_VERSION )
      response = self.response_xml(version, "/statistics/#{event_id}.xml")
      return GameStats.new(response.xpath("/statistics"))
    end

    ##
    # Fetch MLB Game Boxscore
    def self.game_boxscore(event_id, version = DEFAULT_VERSION )
      response = self.response_xml(version, "/boxscore/#{event_id}.xml")
      return Boxscore.new(response.xpath("/boxscore"))
    end

    ##
    # Fetches MLB team roster
    def self.team_roster(year=Date.today.year, version = DEFAULT_VERSION)
      response = self.response_xml(version, "/rosters-full/#{year}.xml")
      return Players.new(response.xpath("rosters"))
    end

    ##
    # Fetches MLB team stats
    def self.team_season_stats(year, version = DEFAULT_VERSION)
      response = self.response_xml(version, "/seasontd/teams/#{year}.xml")
      TeamSeasonStats.new(response.xpath('statistics'))
    end

    ##
    # Fetches MLB player season stats and returns for EVERY PLAYER ARE YOU SERIOUS
    def self.player_season_stats(year, version = DEFAULT_VERSION)
      response = self.response_xml(version, "/seasontd/players/#{year}.xml")
      PlayerSeasonStats.new(response.xpath('statistics'))
    end

    ##
    # Fetches MLB divisional standings
    def self.standings(year, version = DEFAULT_VERSION)
      response = self.response_xml(version, "/rankings/#{year}.xml")
      Standings.new(response.xpath('rankings').first)
    end

    private
    def self.response_xml(version, url)
      base_url = BASE_URL % { access_level: SportsDataApi.access_level(SPORT), version: version }
      response = SportsDataApi.generic_request("#{base_url}#{url}", SPORT)
      Nokogiri::XML(response.to_s).remove_namespaces!
    end
  end
end
