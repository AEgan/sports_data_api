require 'spec_helper'

describe SportsDataApi::Nhl::Game, vcr: {
    cassette_name: 'sports_data_api_nhl_game',
    record: :new_episodes,
    match_requests_on: [:host, :path]
} do
  let(:season) do
    SportsDataApi.set_key(:nhl, api_key(:nhl))
    SportsDataApi.set_access_level(:nhl, 't')
    SportsDataApi::Nhl.schedule(2013, :REG)
  end
  let(:game_summary) do
    SportsDataApi.set_key(:nhl, api_key(:nhl))
    SportsDataApi.set_access_level(:nhl, 't')
    SportsDataApi::Nhl.game_summary('80537b50-8d5d-474e-98c7-a8b381c1ed48')
  end
  let(:daily_schedule) do
    SportsDataApi.set_access_level(:nhl, 't')
    SportsDataApi.set_key(:nhl, api_key(:nhl))
    SportsDataApi::Nhl.daily(2013, 10, 10)
  end
  context 'results from schedule fetch' do
    subject { season.games.first }
    it { should be_an_instance_of(SportsDataApi::Nhl::Game) }
    its(:id) { should eq 'f0f7e327-3a3a-410b-be75-0956c90c4988' }
    its(:scheduled) { should eq Time.new(2013, 10, 01, 19, 00, 00, '-04:00') }
    its(:home) { should eq '441713b7-0f24-11e2-8525-18a905767e44' }
    its(:away) { should eq '441730a9-0f24-11e2-8525-18a905767e44' }
    its(:status) { should eq 'closed' }
    its(:clock) { should be_nil }
    its(:period) { should be_nil }
    its(:home_team) { should be_an_instance_of(SportsDataApi::Nhl::Team) }
    its(:away_team) { should be_an_instance_of(SportsDataApi::Nhl::Team) }
    its(:venue) { should be_an_instance_of(SportsDataApi::Nhl::Venue) }
    its(:broadcast) { should be_an_instance_of(SportsDataApi::Nhl::Broadcast) }
  end
  context 'results from game_summary fetch' do
    subject { game_summary }
    it { should be_an_instance_of(SportsDataApi::Nhl::Game) }
    its(:id) { should eq '80537b50-8d5d-474e-98c7-a8b381c1ed48' }
    its(:scheduled) { should eq Time.new(2013, 10, 10, 22, 00, 00, '-04:00') }
    its(:home) { should eq '441862de-0f24-11e2-8525-18a905767e44' }
    its(:away) { should eq '441781b9-0f24-11e2-8525-18a905767e44' }
    its(:status) { should eq 'closed' }
    its(:clock) { should eq '00:00' }
    its(:period) { should eq 3 }
    its(:home_team) { should be_an_instance_of(SportsDataApi::Nhl::Team) }
    its(:away_team) { should be_an_instance_of(SportsDataApi::Nhl::Team) }
    its(:venue) { should be_an_instance_of(SportsDataApi::Nhl::Venue) }
    its(:broadcast) { should be_an_instance_of(SportsDataApi::Nhl::Broadcast) }
  end
  context 'results from daily schedule fetch' do
    subject { daily_schedule.first }
    it { should be_an_instance_of(SportsDataApi::Nhl::Game) }
    its(:id) { should eq 'f24275a9-4f30-4a81-abdf-d16a9aeda087' }
    its(:scheduled) { should eq Time.new(2013, 10, 10, 19, 00, 00, '-04:00') }
    its(:home) { should eq '4416d559-0f24-11e2-8525-18a905767e44' }
    its(:away) { should eq '44167db4-0f24-11e2-8525-18a905767e44' }
    its(:status) { should eq 'closed' }
    its(:clock) { should be_nil }
    its(:period) { should be_nil }
    its(:home_team) { should be_an_instance_of(SportsDataApi::Nhl::Team) }
    its(:away_team) { should be_an_instance_of(SportsDataApi::Nhl::Team) }
    its(:venue) { should be_an_instance_of(SportsDataApi::Nhl::Venue) }
    its(:broadcast) { should be_an_instance_of(SportsDataApi::Nhl::Broadcast) }
  end
end
