require 'spec_helper'

describe SportsDataApi::Mlb::TeamSeasonStats, vcr: {
    cassette_name: 'sports_data_api_mlb_team_season_stats',
    record: :new_episodes,
    match_requests_on: [:host, :path]
} do
  before do
    SportsDataApi.set_key(:mlb, api_key(:mlb))
    SportsDataApi.set_access_level(:mlb, 't')
  end
  let(:team_stats) { SportsDataApi::Nfl.team_season_stats("BUF", 2013, "REG") }
  let(:phillies) { team_stats.phillies }
  let(:hitting) { phillies[:hitting] }
  let(:pitching) { phillies[:pitching] }
  let(:fielding) { phillies[:fielding] }
  context "team_stats" do
    subject { team_stats }
    describe 'meta methods' do
      it { should respond_to :id }
      it { should respond_to :year }
      it { should respond_to :phillies }
      it { should respond_to :yankees }
    end
  end

  context "phillies" do
    subject { phillies }
    describe "attributes" do
      it { subject[:id].should eq "2142e1ba-3b40-445c-b8bb-f1f8b1054220" }
      it { subject[:name].should eq "Phillies" }
      it { subject[:hitting].kind_of?(Hash).should be true }
      it { subject[:pitching].kind_of?(Hash).should be true }
      it { subject[:fielding].kind_of?(Hash).should be true }
    end
  end
  context "hitting" do
    subject { hitting }
    describe "attributes" do
      it { subject[:ab].should eq 5603 }
      it { subject[:ap].should eq 6197 }
      it { subject[:avg].should eq 0.242 }
      it { subject[:lob].should eq 2351 }
      it { subject[:pcount].should eq 23874 }
      it { subject[:rbi].should eq 584 }
      it { subject[:abhr].should eq 44.824 }
      it { subject[:abk].should eq 4.29 }
      it { subject[:bip].should eq 4209 }
      it { subject[:babip].should eq 0.292 }
      it { subject[:bbk].should eq 0.307 }
      it { subject[:bbpa].should eq 0.065 }
      it { subject[:gofo].should eq 1.24 }
      it { subject[:iso].should eq 0.121 }
      it { subject[:obp].should eq 0.302 }
      it { subject[:ops].should eq 0.665 }
      it { subject[:seca].should eq 0.065 }
      it { subject[:slg].should eq 0.363 }
      it { subject[:xbh].should eq 403 }
      it { subject[:onbase].kind_of?(Hash).should be true }
      it { subject[:runs].kind_of?(Hash).should be true }
      it { subject[:outcome].kind_of?(Hash).should be true }
      it { subject[:outs].kind_of?(Hash).should be true }
      it { subject[:steal].kind_of?(Hash).should be true }
    end
    describe "onbase" do
      it { subject[:onbase][:h].should eq 1356 }
      it { subject[:onbase][:s].should eq 953 }
      it { subject[:onbase][:d].should eq 251 }
      it { subject[:onbase][:t].should eq 27 }
      it { subject[:onbase][:hr].should eq 125 }
      it { subject[:onbase][:tb].should eq 2036 }
      it { subject[:onbase][:bb].should eq 401 }
      it { subject[:onbase][:ibb].should eq 42 }
      it { subject[:onbase][:hbp].should eq 55 }
      it { subject[:onbase][:fc].should eq 154 }
      it { subject[:onbase][:roe].should eq 54 }
    end
    describe "runs" do
      it {subject[:runs][:unearned].should eq 0 }
      it {subject[:runs][:earned].should eq 619 }
      it {subject[:runs][:total].should eq 619 }
    end
    describe "outcome" do
      it { subject[:outcome][:klook].should eq 4028 }
      it { subject[:outcome][:kswing].should eq 1511 }
      it { subject[:outcome][:ktotal].should eq 5539 }
      it { subject[:outcome][:ball].should eq 7567 }
      it { subject[:outcome][:iball].should eq 98 }
      it { subject[:outcome][:dirtball].should eq 406 }
      it { subject[:outcome][:foul].should eq 0 }
    end
    describe "outs" do
      it { subject[:outs][:klook].should eq 271 }
      it { subject[:outs][:kswing].should eq 1035 }
      it { subject[:outs][:ktotal].should eq 1306 }
      it { subject[:outs][:po].should eq 278 }
      it { subject[:outs][:fo].should eq 721 }
      it { subject[:outs][:fidp].should eq 3 }
      it { subject[:outs][:lo].should eq 363 }
      it { subject[:outs][:lidp].should eq 14 }
      it { subject[:outs][:go].should eq 1732 }
      it { subject[:outs][:gidp].should eq 94 }
      it { subject[:outs][:sacfly].should eq 37 }
      it { subject[:outs][:sachit].should eq 59 }
    end
    describe "steal" do
      it { subject[:steal][:caught].should eq 26 }
      it { subject[:steal][:stolen].should eq 109 }
      it { subject[:steal][:pct].should eq 0.807 }
    end
  end
  context "pitching" do
    subject { pitching }
    describe "attributes" do
      it { subject[:pcount].should eq 23682 }
      it { subject[:error].should eq 0 }
      it { subject[:ip_1].should eq 4405 }
      it { subject[:ip_2].should eq 1468.1 }
      it { subject[:bf].should eq 6261 }
      it { subject[:oba].should eq 0.252 }
      it { subject[:lob].should eq 2420 }
      it { subject[:era].should eq 3.806 }
      it { subject[:k9].should eq 7.695 }
      it { subject[:whip].should eq 1.306 }
      it { subject[:kbb].should eq 2.63 }
      it { subject[:gofo].should eq 1.186 }
      it { subject[:onbase].kind_of?(Hash).should be true }
      it { subject[:runs].kind_of?(Hash).should be true }
      it { subject[:outcome].kind_of?(Hash).should be true }
      it { subject[:outs].kind_of?(Hash).should be true }
      it { subject[:steal].kind_of?(Hash).should be true }
      it { subject[:games].kind_of?(Hash).should be true }
    end
    describe "onbase" do
      it { subject[:onbase][:h].should eq 1396 }
      it { subject[:onbase][:s].should eq 946 }
      it { subject[:onbase][:d].should eq 284 }
      it { subject[:onbase][:t].should eq 32 }
      it { subject[:onbase][:hr].should eq 134 }
      it { subject[:onbase][:tb].should eq 2146 }
      it { subject[:onbase][:bb].should eq 478 }
      it { subject[:onbase][:ibb].should eq 43 }
      it { subject[:onbase][:hbp].should eq 69 }
      it { subject[:onbase][:fc].should eq 0 }
      it { subject[:onbase][:roe].should eq 0 }
    end
    describe "runs" do
      it { subject[:runs][:unearned].should eq 66 }
      it { subject[:runs][:earned].should eq 621 }
      it { subject[:runs][:total].should eq 687 }
    end
    describe "outcome" do
      it { subject[:outcome][:klook].should eq 3649 }
      it { subject[:outcome][:kswing].should eq 1627 }
      it { subject[:outcome][:ktotal].should eq 5276 }
      it { subject[:outcome][:ball].should eq 7565 }
      it { subject[:outcome][:iball].should eq 102 }
      it { subject[:outcome][:dirtball].should eq 468 }
      it { subject[:outcome][:foul].should eq 0 }
    end
    describe "outs" do
      it { subject[:outs][:klook].should eq 319 }
      it { subject[:outs][:kswing].should eq 936 }
      it { subject[:outs][:ktotal].should eq 1255 }
      it { subject[:outs][:po].should eq 262 }
      it { subject[:outs][:fo].should eq 683 }
      it { subject[:outs][:fidp].should eq 2 }
      it { subject[:outs][:lo].should eq 388 }
      it { subject[:outs][:lidp].should eq 10 }
      it { subject[:outs][:go].should eq 1638 }
      it { subject[:outs][:gidp].should eq 110 }
      it { subject[:outs][:sacfly].should eq 48 }
      it { subject[:outs][:sachit].should eq 77 }
    end
    describe "steal" do
      it { subject[:steal][:caught].should eq 45 }
      it { subject[:steal][:stolen].should eq 105 }
    end
    describe "games" do
      it { subject[:games][:complete].should eq 2 }
      it { subject[:games][:win].should eq 73 }
      it { subject[:games][:loss].should eq 89 }
      it { subject[:games][:save].should eq 40 }
      it { subject[:games][:svo].should eq 56 }
      it { subject[:games][:hold].should eq 58 }
      it { subject[:games][:blown_save].should eq 16 }
      it { subject[:games][:qstart].should eq 85 }
      it { subject[:games][:shutout].should eq 12 }
    end
  end

  context "fielding" do
    subject { fielding }
    describe "attributes" do
      it { subject[:po].should eq 4405 }
      it { subject[:a].should eq 1673 }
      it { subject[:dp].should eq 133 }
      it { subject[:tp].should eq 0 }
      it { subject[:error].should eq 83 }
      it { subject[:tc].should eq 6161 }
      it { subject[:fpct].should eq 0.987 }
    end
  end

end
