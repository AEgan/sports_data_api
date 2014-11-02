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
    describe "total information" do
      it { subject[:total][:games_played].should eq 82 }
      it { subject[:total][:goals].should eq 233 }
      it { subject[:total][:assists].should eq 402 }
      it { subject[:total][:penalties].should eq 429 }
      it { subject[:total][:penalty_minutes].should eq 1180 }
      it { subject[:total][:team_penalties].should eq 5 }
      it { subject[:total][:team_penalty_minutes].should eq 10 }
      it { subject[:total][:shots].should eq 2490 }
      it { subject[:total][:blocked_att].should eq 1281 }
      it { subject[:total][:missed_shots].should eq 1005 }
      it { subject[:total][:hits].should eq 2174 }
      it { subject[:total][:giveaways].should eq 587 }
      it { subject[:total][:takeaways].should eq 445 }
      it { subject[:total][:blocked_shots].should eq 1200 }
      it { subject[:total][:faceoffs_won].should eq 2506 }
      it { subject[:total][:faceoffs_lost].should eq 2507 }
      it { subject[:total][:powerplays].should eq 274 }
      it { subject[:total][:faceoffs].should eq 5013 }
      it { subject[:total][:faceoff_win_pct].should eq 50.0 }
      it { subject[:total][:shooting_pct].should eq 9.4 }
      it { subject[:total][:points].should eq 635 }
    end
  end
end
