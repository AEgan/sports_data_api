require 'spec_helper'

describe SportsDataApi::Nhl::Broadcast, vcr: {
    cassette_name: 'sports_data_api_nhl_broadcast',
    record: :new_episodes,
    match_requests_on: [:host, :path]
} do
  let(:daily_schedule_one) do
    SportsDataApi.set_access_level(:nhl, 't')
    SportsDataApi.set_key(:nhl, api_key(:nhl))
    SportsDataApi::Nhl.daily(2013, 10, 8)
  end
  let(:daily_schedule_two) do
    SportsDataApi.set_access_level(:nhl, 't')
    SportsDataApi.set_key(:nhl, api_key(:nhl))
    SportsDataApi::Nhl.daily(2013, 10, 9)
  end
  context 'results from daily schedule one fetch' do
    subject { daily_schedule_one.first.broadcast }
    its(:network) { should eq 'ROOT' }
    its(:satellite) { should eq '659' }
  end
  context 'results from daily schedule two fetch' do
    subject { daily_schedule_two.first.broadcast }
    its(:network) { should eq 'NBCSN' }
    its(:satellite) { should eq '220' }
  end
end
