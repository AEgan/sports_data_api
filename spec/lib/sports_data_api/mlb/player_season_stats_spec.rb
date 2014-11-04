require 'spec_helper'

describe SportsDataApi::Mlb::TeamSeasonStats, vcr: {
    cassette_name: 'sports_data_api_mlb_player_season_stats',
    record: :new_episodes,
    match_requests_on: [:host, :path]
} do
  before do
    SportsDataApi.set_key(:mlb, api_key(:mlb))
    SportsDataApi.set_access_level(:mlb, 't')
  end
  let(:player_stats) { SportsDataApi::Mlb.player_season_stats(2014) }
  context "results from player stats fetch" do
    subject { player_stats }
    describe "meta methods" do
      it { should respond_to :year }
    end
  end
end
