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
  let(:total) { flyers[:total] }
  let(:shootouts) { flyers[:shootouts] }
  let(:goaltending) { flyers[:goaltending] }
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
      it { subject[:shootouts].kind_of?(Hash).should be true  }
    end
  end
  context "total stats" do
    subject { total }
    describe "total" do
      it { subject[:games_played].should eq 82 }
      it { subject[:goals].should eq 233 }
      it { subject[:assists].should eq 402 }
      it { subject[:penalties].should eq 429 }
      it { subject[:penalty_minutes].should eq 1180 }
      it { subject[:team_penalties].should eq 5 }
      it { subject[:team_penalty_minutes].should eq 10 }
      it { subject[:shots].should eq 2490 }
      it { subject[:blocked_att].should eq 1281 }
      it { subject[:missed_shots].should eq 1005 }
      it { subject[:hits].should eq 2174 }
      it { subject[:giveaways].should eq 587 }
      it { subject[:takeaways].should eq 445 }
      it { subject[:blocked_shots].should eq 1200 }
      it { subject[:faceoffs_won].should eq 2506 }
      it { subject[:faceoffs_lost].should eq 2507 }
      it { subject[:powerplays].should eq 274 }
      it { subject[:faceoffs].should eq 5013 }
      it { subject[:faceoff_win_pct].should eq 50.0 }
      it { subject[:shooting_pct].should eq 9.4 }
      it { subject[:points].should eq 635 }
      it { subject[:powerplay].kind_of?(Hash).should be true }
      it { subject[:shorthanded].kind_of?(Hash).should be true }
      it { subject[:even_strength].kind_of?(Hash).should be true }
      it { subject[:penalty_shots].kind_of?(Hash).should be true }
      describe "powerplay" do
        it { subject[:powerplay][:faceoffs_won].should eq 288 }
        it { subject[:powerplay][:faceoffs_lost].should eq 260 }
        it { subject[:powerplay][:shots].should eq 450 }
        it { subject[:powerplay][:goals].should eq 58 }
        it { subject[:powerplay][:missed_shots].should eq 187 }
        it { subject[:powerplay][:assists].should eq 116 }
        it { subject[:powerplay][:faceoff_win_pct].should eq 52.6 }
        it { subject[:powerplay][:faceoffs].should eq 548 }
      end
      describe "shorthanded" do
        it { subject[:shorthanded][:faceoffs_won].should eq 292 }
        it { subject[:shorthanded][:faceoffs_lost].should eq 300 }
        it { subject[:shorthanded][:shots].should eq 96 }
        it { subject[:shorthanded][:goals].should eq 8 }
        it { subject[:shorthanded][:missed_shots].should eq 25 }
        it { subject[:shorthanded][:assists].should eq 7 }
        it { subject[:shorthanded][:faceoff_win_pct].should eq 49.3 }
        it { subject[:shorthanded][:faceoffs].should eq 592 }
      end
      describe "even_strength" do
        it { subject[:even_strength][:faceoffs_won].should eq 1926 }
        it { subject[:even_strength][:faceoffs_lost].should eq 1947 }
        it { subject[:even_strength][:shots].should eq 1944 }
        it { subject[:even_strength][:goals].should eq 167 }
        it { subject[:even_strength][:missed_shots].should eq 793 }
        it { subject[:even_strength][:assists].should eq 279 }
        it { subject[:even_strength][:faceoff_win_pct].should eq 49.7 }
        it { subject[:even_strength][:faceoffs].should eq 3873 }
      end
      describe "penalty_shots" do
        it { subject[:penalty_shots][:shots].should eq 3 }
        it { subject[:penalty_shots][:goals].should eq 0 }
        it { subject[:penalty_shots][:missed_shots].should eq 0 }
      end
    end
    context "shootouts" do
      subject { shootouts }
      describe "shootout stats" do
        it { subject[:shots].should eq 32 }
        it { subject[:missed_shots].should eq 7 }
        it { subject[:goals].should eq 11 }
        it { subject[:shots_against].should eq 41 }
        it { subject[:goals_against].should eq 17 }
        it { subject[:saves].should eq 19 }
        it { subject[:saves_pct].should eq 0.463 }
      end
    end
  end
end
