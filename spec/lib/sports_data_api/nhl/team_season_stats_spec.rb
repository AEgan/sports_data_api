require 'spec_helper'

describe SportsDataApi::Nhl::TeamSeasonStats, vcr: {
    cassette_name: 'sports_data_api_nhl_team_season_stats',
    record: :new_episodes,
    match_requests_on: [:host, :path]
} do
  before do
    SportsDataApi.set_key(:nhl, api_key(:nhl))
    SportsDataApi.set_access_level(:nhl, 't')
  end
  let(:team_stats) { SportsDataApi::Nhl.team_season_stats("44179d47-0f24-11e2-8525-18a905767e44", 2013, "REG") }
  let(:flyers) { team_stats.team }
  context "team stats attributes" do
    subject { team_stats }
    describe 'meta methods' do
      it { should respond_to :team }
      it { should respond_to :year }
      it { should respond_to :season }
      it { subject.team.kind_of?(Hash).should be true }
    end
    describe 'season information' do
      it { subject.year.should eq "2013" }
      it { subject.season.should eq "REG" }
    end
  end
  context "team record stats" do
    subject { flyers }
    describe 'team information' do
      it { subject[:id].should eq "44179d47-0f24-11e2-8525-18a905767e44" }
      it { subject[:name].should eq "Flyers" }
      it { subject[:market].should eq "Philadelphia" }
      it { subject[:total].kind_of?(Hash).should be true  }
      it { subject[:goaltending].kind_of?(Hash).should be true  }
    end
  end
end
