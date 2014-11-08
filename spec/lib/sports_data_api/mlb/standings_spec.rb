require 'spec_helper'

describe SportsDataApi::Mlb::Standings, vcr: {
    cassette_name: 'sports_data_api_mlb_standings',
    record: :new_episodes,
    match_requests_on: [:host, :path]
} do
  before do
    SportsDataApi.set_key(:nhl, api_key(:nhl))
    SportsDataApi.set_access_level(:nhl, 't')
  end
  let(:standings) { SportsDataApi::Mlb.standings("2014") }

  context "standings info" do
    subject { standings }
    describe "methods" do
      it { subject.id.should eq "8f4e3a30-8444-11e3-808c-22000a904a71" }
      it { subject.year.should eq "2014" }
      it { subject.nl.kind_of?(Hash).should be true }
      it { subject.al.kind_of?(Hash).should be true }
    end
  end

end
