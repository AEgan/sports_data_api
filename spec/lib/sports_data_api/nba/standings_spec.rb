require 'spec_helper'

describe SportsDataApi::Nba::Standings, vcr: {
    cassette_name: 'sports_data_api_nba_standings',
    record: :new_episodes,
    match_requests_on: [:host, :path]
} do
  let(:standings) do
    SportsDataApi.set_key(:nba, api_key(:nba))
    SportsDataApi.set_access_level(:nba, 't')
    SportsDataApi::Nba.standings(2013, :REG)
  end
  context "standings info" do
    subject { standings }
    it { should be_an_instance_of(SportsDataApi::Nba::Standings) }
    it { subject.year.should eq "2013" }
    it { subject.season.should eq "REG" }
    it { subject.eastern.should be_an_instance_of(Hash) }
    it { subject.western.should be_an_instance_of(Hash) }
  end
end
