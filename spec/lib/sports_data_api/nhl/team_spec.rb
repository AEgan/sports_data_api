require 'spec_helper'

describe SportsDataApi::Nhl::Team, vcr: {
    cassette_name: 'sports_data_api_nhl_team',
    record: :new_episodes,
    match_requests_on: [:host, :path]
} do
  let(:teams) do
    SportsDataApi.set_key(:nhl, api_key(:nhl))
    SportsDataApi.set_access_level(:nhl, 't')
    SportsDataApi::Nhl.teams
  end
  context 'results from teams fetch (first team)' do
    subject { teams.first }
    it { should be_an_instance_of(SportsDataApi::Nhl::Team) }
    its(:id) { should eq "44151f7a-0f24-11e2-8525-18a905767e44" }
    its(:alias) { should eq 'LA' }
    its(:conference) { should eq 'WESTERN' }
    its(:division) { should eq 'PACIFIC' }
    its(:market) { should eq 'Los Angeles' }
    its(:name) { should eq 'Kings' }
    its(:venue) { should be_an_instance_of SportsDataApi::Nhl::Venue }
  end
  context 'results from teams fetch (second team)' do
    subject { teams[:"44153da1-0f24-11e2-8525-18a905767e44"] }
    it { should be_an_instance_of(SportsDataApi::Nhl::Team) }
    its(:id) { should eq "44153da1-0f24-11e2-8525-18a905767e44" }
    its(:alias) { should eq 'ARI' }
    its(:conference) { should eq 'WESTERN' }
    its(:division) { should eq 'PACIFIC' }
    its(:market) { should eq 'Arizona' }
    its(:name) { should eq 'Coyotes' }
    its(:venue) { should be_an_instance_of SportsDataApi::Nhl::Venue }
  end

  context 'using players from the get_roster method' do
    subject { teams.first.get_roster.first }
    its(:id) { should eq '3abc026d-b911-11e2-8051-f4ce4684ea4c' }
    its(:status) { should eq 'ACT' }
    its(:full_name) { should eq 'Tanner Pearson' }
    its(:first_name) { should eq 'Tanner' }
    its(:last_name) { should eq 'Pearson' }
    its(:abbr_name) { should eq 'T.Pearson' }
    its(:height) { should eq '72' }
    its(:weight) { should eq '193' }
    its(:position) { should eq 'F' }
    its(:primary_position) { should eq 'C' }
    its(:jersey_number) { should eq '70' }
    its(:experience) { should eq '1' }
    its(:birth_place) { should eq 'Kitchener, ON, CAN' }
    its(:birthdate) { should eq "1992-08-10" }
    its(:draft_round) { should eq "1" }
    its(:draft_pick) { should eq "30" }
  end

  context 'get venue information' do
    subject { teams.first.venue }
    its(:id) { should eq "dec253d4-68df-470b-b8fc-d663a7fa4704" }
    its(:name) { should eq "Staples Center" }
    its(:capacity) { should eq "18118" }
    its(:address) { should eq "1111 S. Figueroa St." }
    its(:city) { should eq "Los Angeles" }
    its(:state) { should eq "CA" }
    its(:zip) { should eq "90015" }
    its(:country) { should eq "USA" }
  end
end
