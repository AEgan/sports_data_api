require 'spec_helper'

describe SportsDataApi::Nba, vcr: {
  cassette_name: 'sports_data_api_nba_player_season_stats',
  record: :new_episodes,
  match_requests_on: [:host, :path]
  } do
    context 'results from daily schedule fetch' do
      let(:stats) do
        SportsDataApi.set_access_level(:nba, 't')
        SportsDataApi.set_key(:nba, api_key(:nba))
        SportsDataApi::Nba.player_season_stats("2013", "REG", "583ecfff-fb46-11e1-82cb-f4ce4684ea4c")
      end
      subject { stats }
      it { should be_an_instance_of(Hash) }
    end
  end
