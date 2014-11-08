require 'spec_helper'

describe SportsDataApi::Nhl::PlayerSeasonStats, vcr: {
    cassette_name: 'sports_data_api_nhl_player_season_stats',
    record: :new_episodes,
    match_requests_on: [:host, :path]
} do
  before do
    SportsDataApi.set_key(:nhl, api_key(:nhl))
    SportsDataApi.set_access_level(:nhl, 't')
  end
  let(:player_stats) { SportsDataApi::Nhl.player_season_stats("3abc026d-b911-11e2-8051-f4ce4684ea4c") }
  let(:player) { player_stats.player }
  let(:season) { player.seasons.first }
  let(:team) { season[:team] }
  let(:statistics) { team[:statistics] }
  let(:average) { team[:average] }
  let(:time_on_ice) { team[:time_on_ice] }
  context "player stats" do
    subject { player_stats }
    describe "methods" do
      it { subject.id.should eq "3abc026d-b911-11e2-8051-f4ce4684ea4c" }
      it { subject.seasons.kind_of(Array).should be true }
      it { subject.player.kind_of(SportsDataApi::Nhl::Player).should be true }
    end
  end

  context "player info" do
    subject { player }
    describe "methods" do
        it { subject.id.should eq '3abc026d-b911-11e2-8051-f4ce4684ea4c' }
        it { subject.status.should eq 'ACT' }
        it { subject.full_name.should eq 'Tanner Pearson' }
        it { subject.first_name.should eq 'Tanner' }
        it { subject.last_name.should eq 'Pearson' }
        it { subject.abbr_name.should eq 'T.Pearson' }
        it { subject.height.should eq '72' }
        it { subject.weight.should eq '193' }
        it { subject.position.should eq 'F' }
        it { subject.primary_position.should eq 'C' }
        it { subject.jersey_number.should eq '70' }
        it { subject.experience.should eq '1' }
        it { subject.birth_place.should eq 'Kitchener, ON, CAN' }
        it { subject.birthdate.should eq "1992-08-10" }
        it { subject.draft_round.should eq "1" }
        it { subject.draft_pick.should eq "30" }
    end
  end
  context "season info" do
    subject { season }
    describe "attributes" do
      it { subject[:id].should eq "a64701af-85bb-4cc0-bf72-15f6ba69757e" }
      it { subject[:year].should eq "2013" }
      it { subject[:type].should eq "REG" }
      it { subject[:team].kind_of(Hash).should be true }
    end
  end

  context "team info" do
    subject { team }
    describe "attributes" do
      it { subject[:id].should eq "44151f7a-0f24-11e2-8525-18a905767e44" }
      it { subject[:name].should eq "Kings" }
      it { subject[:market].should eq "Los Angeles" }
      it { subject[:alias].should eq "LA" }
      it { subject[:statistics].kind_of(Hash).should be true }
      it { subject[:time_on_ice].kind_of(Hash).should be true }
    end
  end

  context "statistics info" do
    subject { statistics }
    describe "total" do
      it { subject[:total][:games_played].should eq 25 }
      it { subject[:total][:goals].should eq 3 }
      it { subject[:total][:assists].should eq 4 }
      it { subject[:total][:penalties].should eq 4 }
      it { subject[:total][:penalty_minutes].should eq 8 }
      it { subject[:total][:shots].should eq 31 }
      it { subject[:total][:blocked_att].should eq 11 }
      it { subject[:total][:missed_shots].should eq 20 }
      it { subject[:total][:hits].should eq 35 }
      it { subject[:total][:giveaways].should eq 9 }
      it { subject[:total][:takeaways].should eq 9 }
      it { subject[:total][:blocked_shots].should eq 9 }
      it { subject[:total][:faceoffs_won].should eq 1 }
      it { subject[:total][:faceoffs_lost].should eq 1 }
      it { subject[:total][:winning_goals].should eq 1 }
      it { subject[:total][:plus_minus].should eq 2 }
      it { subject[:total][:games_scratched].should eq 17 }
      it { subject[:total][:shooting_pct].should eq 9.7 }
      it { subject[:total][:faceoffs].should eq 2 }
      it { subject[:total][:faceoff_win_pct].should eq 50.0 }
      it { subject[:total][:points].should eq 7 }
    end
    describe "powerplay" do
      it { subject[:powerplay][:shots].should eq 4 }
      it { subject[:powerplay][:goals].should eq 1 }
      it { subject[:powerplay][:missed_shots].should eq 1 }
      it { subject[:powerplay][:assists].should eq 0 }
    end
    describe "shorthanded" do
      it { subject[:shorthanded][:shots].should eq 0 }
      it { subject[:shorthanded][:goals].should eq 0 }
      it { subject[:shorthanded][:missed_shots].should eq 0 }
      it { subject[:shorthanded][:assists].should eq 0 }
    end
    describe "even_strength" do
      it { subject[:even_strength][:missed_shots].should eq 19 }
      it { subject[:even_strength][:goals].should eq 2 }
      it { subject[:even_strength][:shots].should eq 27 }
      it { subject[:even_strength][:assists].should eq 4 }
    end
    describe "penalty_shots" do
      it { subject[:penalty_shots][:shots].should eq 0 }
      it { subject[:penalty_shots][:goals].should eq 0 }
      it { subject[:penalty_shots][:missed_shots].should eq 0 }
    end
    describe "shootouts" do
      it { subject[:shootout][:shots].should eq 0 }
      it { subject[:shootout][:missed_shots].should eq 0 }
      it { subject[:shootout][:goals].should eq 0 }
    end
  end
  context "average stats" do
    subject { average }
    describe "attributes" do
      it { subject[:points].should eq 0.28 }
      it { subject[:blocked_att].should eq 0.44 }
      it { subject[:missed_shots].should eq 0.8 }
      it { subject[:takeaways].should eq 0.36 }
      it { subject[:assists].should eq 0.16 }
      it { subject[:shots].should eq 1.24 }
      it { subject[:penalty_minutes].should eq 0.32 }
      it { subject[:hits].should eq 1.4 }
      it { subject[:goals].should eq 0.12 }
      it { subject[:giveaways].should eq 0.36 }
      it { subject[:blocked_shots].should eq 0.36 }
      it { subject[:penalties].should eq 0.16 }
    end
  end
  context "time on ice" do
    subject { time_on_ice }
    describe "attributes" do
      it { subject[:shifts].should eq 388 }
      it { subject[:total].should eq 270:13 }
      it { subject[:shifts_pg].should eq 15.52 }
      it { subject[:toi_pg].should eq "10:49" }
    end
  end
end
