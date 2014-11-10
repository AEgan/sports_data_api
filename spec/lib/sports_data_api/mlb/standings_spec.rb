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
  let(:al) { standings.al }
  let(:central) { al[:divisions][:c] }
  let(:teams) { central[:teams] }

  context "standings info" do
    subject { standings }
    describe "methods" do
      it { subject.id.should eq "8f4e3a30-8444-11e3-808c-22000a904a71" }
      it { subject.year.should eq "2014" }
      it { subject.nl.kind_of?(Hash).should be true }
      it { subject.al.kind_of?(Hash).should be true }
    end
  end
  context "league info" do
    subject { al }
    describe "attributes" do
      it { subject[:id].should eq 'AL' }
      it { subject[:divisions].kind_of?(Hash).should be true }
    end
    describe "divisions" do
      it { subject[:divisions][:c].kind_of?(Hash).should be true }
      it { subject[:divisions][:e].kind_of?(Hash).should be true }
      it { subject[:divisions][:w].kind_of?(Hash).should be true }
    end
  end

  context "division info" do
    subject { central }
    describe "attributes" do
      it { subject[:id].should eq "C" }
      it { subject[:teams].kind_of?(Array).should be true }
    end
    describe "teams" do
      it { subject[:teams].length.should eq 5 }
      it { subject[:teams][0].kind_of?(Hash).should be true }
      it { subject[:teams][1].kind_of?(Hash).should be true }
      it { subject[:teams][2].kind_of?(Hash).should be true }
      it { subject[:teams][3].kind_of?(Hash).should be true }
      it { subject[:teams][4].kind_of?(Hash).should be true }
    end
    describe "Detroit" do
      it { subject[:teams][0][:id].should eq "575c19b7-4052-41c2-9f0a-1c5813d02f99" }
      it { subject[:teams][0][:name].should eq "Tigers" }
      it { subject[:teams][0][:market].should eq "Detroit" }
    end
    describe "KC" do
      it { subject[:teams][1][:id].should eq "833a51a9-0d84-410f-bd77-da08c3e5e26e" }
      it { subject[:teams][1][:name].should eq "Royals" }
      it { subject[:teams][1][:market].should eq "Kansas City" }
    end
    describe "Cleveland" do
      it { subject[:teams][2][:id].should eq "80715d0d-0d2a-450f-a970-1b9a3b18c7e7" }
      it { subject[:teams][2][:name].should eq "Indians" }
      it { subject[:teams][2][:market].should eq "Cleveland" }
    end
    describe "Chicago" do
      it { subject[:teams][3][:id].should eq "47f490cd-2f58-4ef7-9dfd-2ad6ba6c1ae8" }
      it { subject[:teams][3][:name].should eq "White Sox" }
      it { subject[:teams][3][:market].should eq "Chicago" }
    end
    describe "Minnesota" do
      it { subject[:teams][4][:id].should eq "aa34e0ed-f342-4ec6-b774-c79b47b60e2d" }
      it { subject[:teams][4][:name].should eq "Twins" }
      it { subject[:teams][4][:market].should eq "Minnesota" }
    end
  end
  context "ranks" do
    subject { teams }
    describe "division" do
      it { subject[0][:rank][:division].should eq 1 }
      it { subject[1][:rank][:division].should eq 2 }
      it { subject[2][:rank][:division].should eq 3 }
      it { subject[3][:rank][:division].should eq 4 }
      it { subject[4][:rank][:division].should eq 5 }
    end
    describe "league" do
      it { subject[0][:rank][:league].should eq 3 }
      it { subject[1][:rank][:league].should eq 4 }
      it { subject[2][:rank][:league].should eq 7 }
      it { subject[3][:rank][:league].should eq 11 }
      it { subject[4][:rank][:league].should eq 14 }
    end
  end

end
