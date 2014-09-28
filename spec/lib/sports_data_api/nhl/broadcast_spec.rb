require 'spec_helper'

describe SportsDataApi::Nhl::Broadcast, vcr: {
    cassette_name: 'sports_data_api_nhl_broadcast',
    record: :new_episodes,
    match_requests_on: [:host, :path]
} do
  let(:daily_schedule) do
    SportsDataApi.set_access_level(:nhl, 't')
    SportsDataApi.set_key(:nhl, api_key(:nhl))
    SportsDataApi::Nhl.daily(2013, 10, 9)
  end
  context 'results from daily schedule first game fetch' do
    subject { daily_schedule.first.broadcast }
    its(:network) { should eq 'NBCSN' }
    its(:satellite) { should eq '220' }
  end
  context 'results from daily schedule last game fetch' do
    subject { daily_schedule.games.last.broadcast }
    its(:network) { should eq 'FS-W' }
    its(:satellite) { should eq '692' }
  end
end
