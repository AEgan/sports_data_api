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
  let(:western) do
    standings.western
  end
  let(:pacific) do
    western[:divisions][:pacific]
  end
  context "standings info" do
    subject { standings }
    it { should be_an_instance_of(SportsDataApi::Nba::Standings) }
    it { subject.year.should eq "2013" }
    it { subject.season.should eq "REG" }
    it { subject.eastern.should be_an_instance_of(Hash) }
    it { subject.western.should be_an_instance_of(Hash) }
  end
  context "western info" do
    subject { western }
    it { subject.should be_an_instance_of(Hash) }
    it { subject[:id].should eq "7fe7e212-de01-4f8f-a31d-b9f0a95731e3" }
    it { subject[:name].should eq "WESTERN CONFERENCE" }
    it { subject[:alias].should eq "WESTERN" }
    it { subject[:divisions].should be_an_instance_of(Hash) }
    it { subject[:divisions].length.should eq 3 }
  end
  context "pacific info" do
    subject { pacific }
    it { subject.should be_an_instance_of(Hash) }
    it { subject[:teams].should be_an_instance_of(Array) }
  end
end
