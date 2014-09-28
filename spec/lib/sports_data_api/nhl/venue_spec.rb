require 'spec_helper'

describe SportsDataApi::Nhl::Venue, vcr: {
    cassette_name: 'sports_data_api_nhl_venue',
    record: :new_episodes,
    match_requests_on: [:host, :path]
} do
  let(:daily_schedule) do
    SportsDataApi.set_access_level(:nhl, 't')
    SportsDataApi.set_key(:nhl, api_key(:nhl))
    SportsDataApi::Nhl.daily(2013, 10, 9)
  end
  context 'results from daily schedule first game fetch' do
    subject { daily_schedule.first.venue }
    its(:id) { should eq '14e923b7-a636-476f-b810-b15967787e3c' }
    its(:name) { should eq 'Scottrade Center' }
    its(:address) { should eq '1401 Clark Ave.' }
    its(:city) { should eq 'St. Louis' }
    its(:state) { should eq 'MO' }
    its(:zip) { '63103' }
    its(:country) { should eq 'USA' }
    its(:capacity) { should eq '19150' }
  end
  context 'results from daily schedule last game fetch' do
    subject { daily_schedule.games.last.venue }
    its(:id) { should eq 'dec253d4-68df-470b-b8fc-d663a7fa4704' }
    its(:name) { should eq 'Staples Center' }
    its(:address) { should eq '1111 S. Figueroa St.' }
    its(:city) { should eq 'Los Angeles' }
    its(:state) { should eq 'CA' }
    its(:zip) { '90015' }
    its(:country) { should eq 'USA' }
    its(:capacity) { should eq '18118' }
  end
end
