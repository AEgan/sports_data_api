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
  let(:warriors) do
    pacific[:teams][1]
  end
  let(:records) do
    warriors[:records]
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
  context "warriors info" do
    subject { warriors }
    it { subject[:id].should eq "583ec825-fb46-11e1-82cb-f4ce4684ea4c" }
    it { subject[:name].should eq "Warriors" }
    it { subject[:market].should eq "Golden State" }
    it { subject[:wins].should eq 51 }
    it { subject[:losses].should eq 31 }
    it { subject[:win_pct].should eq 0.622 }
    it { subject[:points_for].should eq 104.26 }
    it { subject[:points_against].should eq 99.45 }
    it { subject[:point_diff].should eq 4.81 }
    it { subject[:records].should be_an_instance_of Hash }
  end
  context "records info" do
    subject { records }
    it { subject }
    it { subject[:atlantic].should be_an_instance_of Hash }
    it { subject[:below_500].should be_an_instance_of Hash }
    it { subject[:central].should be_an_instance_of Hash }
    it { subject[:conference].should be_an_instance_of Hash }
    it { subject[:division].should be_an_instance_of Hash }
    it { subject[:home].should be_an_instance_of Hash }
    it { subject[:last_10].should be_an_instance_of Hash }
    it { subject[:last_10_home].should be_an_instance_of Hash }
    it { subject[:last_10_road].should be_an_instance_of Hash }
    it { subject[:northwest].should be_an_instance_of Hash }
    it { subject[:over_500].should be_an_instance_of Hash }
    it { subject[:overtime].should be_an_instance_of Hash }
    it { subject[:pacific].should be_an_instance_of Hash }
    it { subject[:road].should be_an_instance_of Hash }
    it { subject[:southeast].should be_an_instance_of Hash }
    it { subject[:southwest].should be_an_instance_of Hash }
    it { subject[:ten_points].should be_an_instance_of Hash }
    it { subject[:three_points].should be_an_instance_of Hash }
    describe 'atlantic' do
      it { subject[:atlantic][:wins].should eq 7 }
      it { subject[:atlantic][:losses].should eq 3 }
      it { subject[:atlantic][:win_pct].should eq 0.7 }
    end
    describe 'below_500' do
      it { subject[:below_500][:wins].should eq 26 }
      it { subject[:below_500][:losses].should eq 11 }
      it { subject[:below_500][:win_pct].should eq 0.703 }
    end
    describe 'central' do
      it { subject[:central][:wins].should eq 7 }
      it { subject[:central][:losses].should eq 3 }
      it { subject[:central][:win_pct].should eq 0.7 }
    end
    describe 'conference' do
      it { subject[:conference][:wins].should eq 31 }
      it { subject[:conference][:losses].should eq 21 }
      it { subject[:conference][:win_pct].should eq 0.596 }
    end
    describe 'division' do
      it { subject[:division][:wins].should eq 11 }
      it { subject[:division][:losses].should eq 5 }
      it { subject[:division][:win_pct].should eq 0.688 }
    end
    describe 'home' do
      it { subject[:home][:wins].should eq 27 }
      it { subject[:home][:losses].should eq 14 }
      it { subject[:home][:win_pct].should eq 0.659 }
    end
    describe 'last_10' do
      it { subject[:last_10][:wins].should eq 6 }
      it { subject[:last_10][:losses].should eq 4 }
      it { subject[:last_10][:win_pct].should eq 0.6 }
    end
    describe 'last_10_home' do
      it { subject[:last_10_home][:wins].should eq 6 }
      it { subject[:last_10_home][:losses].should eq 4 }
      it { subject[:last_10_home][:win_pct].should eq 0.6 }
    end
    describe 'last_10_road' do
      it { subject[:last_10_road][:wins].should eq 6 }
      it { subject[:last_10_road][:losses].should eq 4 }
      it { subject[:last_10_road][:win_pct].should eq 0.6 }
    end
    describe 'northwest' do
      it { subject[:northwest][:wins].should eq 11 }
      it { subject[:northwest][:losses].should eq 7 }
      it { subject[:northwest][:win_pct].should eq 0.611 }
    end
    describe 'over_500' do
      it { subject[:over_500][:wins].should eq 25 }
      it { subject[:over_500][:losses].should eq 20 }
      it { subject[:over_500][:win_pct].should eq 0.556 }
    end
    describe 'overtime' do
      it { subject[:overtime][:wins].should eq 3 }
      it { subject[:overtime][:losses].should eq 3 }
      it { subject[:overtime][:win_pct].should eq 0.5 }
    end
    describe 'pacific' do
      it { subject[:pacific][:wins].should eq 11 }
      it { subject[:pacific][:losses].should eq 5 }
      it { subject[:pacific][:win_pct].should eq 0.688 }
    end
    describe 'road' do
      it { subject[:road][:wins].should eq 24 }
      it { subject[:road][:losses].should eq 17 }
      it { subject[:road][:win_pct].should eq 0.585 }
    end
    describe 'southeast' do
      it { subject[:southeast][:wins].should eq 6 }
      it { subject[:southeast][:losses].should eq 4 }
      it { subject[:southeast][:win_pct].should eq 0.6 }
    end
    describe 'southwest' do
      it { subject[:southwest][:wins].should eq 9 }
      it { subject[:southwest][:losses].should eq 9 }
      it { subject[:southwest][:win_pct].should eq 0.5 }
    end
    describe 'ten_points' do
      it { subject[:ten_points][:wins].should eq 28 }
      it { subject[:ten_points][:losses].should eq 9 }
      it { subject[:ten_points][:win_pct].should eq 0.757 }
    end
    describe 'three_points' do
      it { subject[:three_points][:wins].should eq 11 }
      it { subject[:three_points][:losses].should eq 8 }
      it { subject[:three_points][:win_pct].should eq 0.579 }
    end
  end
end
