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
  end
end
