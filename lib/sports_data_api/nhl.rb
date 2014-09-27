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
  autoload :Season, File.join(DIR, 'season')
  autoload :Venue, File.join(DIR, 'venue')
  autoload :Broadcast, File.join(DIR, 'broadcast')

  ##
  # Fetches NHL season schedule for a given year and season
  def self.schedule(year, season, version = DEFAULT_VERSION)
    season = season.to_s.upcase.to_sym
    raise SportsDataApi::Nhl::Exception.new("#{season} is not a valid season") unless Season.valid?(season)

    response = self.response_xml(version, "/games/#{year}/#{season}/schedule.xml")

    return Season.new(response.xpath("/league/season-schedule"))
  end

  def self.daily(year, month, day, version = DEFAULT_VERSION)
    raise SportsDataApi::Nhl::Exception.new("#{year}-#{month}-#{day} is not a valid date") unless Date.valid_date?(year, month, day)
    response = self.response_xml(version, "/games/#{year}/#{month}/#{day}/schedule.xml")
    return Games.new(response.xpath('league/daily-schedule'))
  end

  private
  def self.response_xml(version, url)
    base_url = BASE_URL % { access_level: SportsDataApi.access_level(SPORT), version: version }
    response = SportsDataApi.generic_request("#{base_url}#{url}", SPORT)
    Nokogiri::XML(response.to_s).remove_namespaces!
  end

  end
end
