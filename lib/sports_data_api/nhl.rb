module SportsDataApi
  module Nhl

  class Exception < ::Exception
  end

  DIR = File.join(File.dirname(__FILE__), 'nhl')
  BASE_URL = 'http://api.sportsdatallc.org/nhl-%{access_level}%{version}'
  DEFAULT_VERSION = 3
  SPORT = :nhl

  autoload :Season, File.join(DIR, 'season')
  autoload :Game, File.join(DIR, 'game')
  autoload :Games, File.join(DIR, 'games')
  autoload :Team, File.join(DIR, 'team')
  autoload :Teams, File.join(DIR, 'teams')
  autoload :Season, File.join(DIR, 'season')
  autoload :Venue, File.join(DIR, 'venue')
  autoload :Broadcast, File.join(DIR, 'broadcast')
  autoload :Player, File.join(DIR, 'player')
  autoload :Standings, File.join(DIR, 'standings')
  autoload :TeamSeasonStats, File.join(DIR, 'team_season_stats')
  autoload :PlayerSeasonStats, File.join(DIR, 'player_season_stats')

  ##
  # Fetches NHL season schedule for a given year and season
  def self.schedule(year, season, version = DEFAULT_VERSION)
    season = season.to_s.upcase.to_sym
    raise SportsDataApi::Nhl::Exception.new("#{season} is not a valid season") unless Season.valid?(season)

    response = self.response_xml(version, "/games/#{year}/#{season}/schedule.xml")

    return Season.new(response.xpath("/league/season-schedule"))
  end

  # fetches the daily schedule for the NHL
  def self.daily(year, month, day, version = DEFAULT_VERSION)
    raise SportsDataApi::Nhl::Exception.new("#{year}-#{month}-#{day} is not a valid date") unless Date.valid_date?(year, month, day)
    response = self.response_xml(version, "/games/#{year}/#{month}/#{day}/schedule.xml")
    return Games.new(response.xpath('league/daily-schedule'))
  end

  # fetches all of the teams for the NHL
  def self.teams(version = DEFAULT_VERSION)
    response = self.response_xml(version, "/league/hierarchy.xml")
    Teams.new(response.xpath('/league'))
  end

  # fetches the roster for the team in the NHL
  # team is the Sprots Data LLC id for the team
  def self.team_roster(team, version = DEFAULT_VERSION)
    response = self.response_xml(version, "/teams/#{team}/profile.xml")

    response.xpath("team/players/player").map { |player| Player.new(player) }
  end

  ##
  # Fetches NHL game summary for a given game
  def self.game_summary(game, version = DEFAULT_VERSION)
    response = self.response_xml(version, "/games/#{game}/summary.xml")
    Game.new(xml: response.xpath("/game"))
  end

  ##
  # Fetches NHL standings for the divisions and conferences
  def self.standings(year, season, version = DEFAULT_VERSION)
    season = season.to_s.upcase.to_sym
    raise SportsDataApi::Nhl::Exception.new("#{season} is not a valid season") unless Season.valid?(season)

    response = self.response_xml(version, "/seasontd/#{year}/#{season}/standings.xml")

    return Standings.new(response.xpath('league/season').first)
  end

  ##
  # Fetches NHL team season stats
  def self.team_season_stats(team_id, year, season, version = DEFAULT_VERSION)
    season = season.to_s.upcase.to_sym
    raise SportsDataApi::Nhl::Exception.new("#{season} is not a valid season") unless Season.valid?(season)
    response = self.response_xml(version, "/seasontd/#{year}/#{season}/teams/#{team_id}/statistics.xml")

    TeamSeasonStats.new(response.xpath('season').first)
  end

  ##
  # Fetches NHL player season stats
  def self.player_season_stats(player_id, version = DEFAULT_VERSION)
    response = self.response_xml(version, "/players/#{player_id}/profile.xml")
    PlayerSeasonStats.new(response.xpath('player').first)
  end

  private
  # helper method that gets the XML froma request (parsed by nokogiri)
  def self.response_xml(version, url)
    base_url = BASE_URL % { access_level: SportsDataApi.access_level(SPORT), version: version }
    response = SportsDataApi.generic_request("#{base_url}#{url}", SPORT)
    Nokogiri::XML(response.to_s).remove_namespaces!
  end

  end
end
