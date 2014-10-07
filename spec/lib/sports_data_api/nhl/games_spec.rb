require 'spec_helper'

describe SportsDataApi::Nhl::Games, vcr: {
    cassette_name: 'sports_data_api_nhl_games',
    record: :new_episodes,
    match_requests_on: [:host, :path]
} do
  context 'results from daily schedule fetch for the tenth' do
    let(:games_tenth) do
      SportsDataApi.set_access_level(:nhl, 't')
      SportsDataApi.set_key(:nhl, api_key(:nhl))
      SportsDataApi::Nhl.daily(2013, 10, 10)
    end

    subject { games_tenth }
    it { should be_an_instance_of(SportsDataApi::Nhl::Games) }
    its(:date) { should eq "2013-10-10" }
    its(:count) { should eq 10 }
  end

end
