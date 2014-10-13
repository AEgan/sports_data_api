require 'spec_helper'

describe SportsDataApi::Nfl::Standings, vcr: {
    cassette_name: 'sports_data_api_nfl_standings',
    record: :new_episodes,
    match_requests_on: [:host, :path]
} do
  let(:standings) do
    SportsDataApi.set_key(:nfl, api_key(:nfl))
    SportsDataApi.set_access_level(:nfl, 't')
    SportsDataApi::Nfl.standings(2013, :REG)
  end
  context 'results from standings fetch' do
    subject { standings }
    it { should be_an_instance_of(SportsDataApi::Nfl::Standings) }
    its(:season) { should eq 2013 }
    its(:type) { should eq "REG" }
    its(:nfc) { should be_an_instance_of(Hash) }
    its(:afc) { should be_an_instance_of(Hash) }
  end
  context 'results from standings : AFC' do
    subject { standings.afc }

    it '#name' do
      expect(subject[:name]).to eq "AFC"
    end
    it '#conferences' do
      expect(subject[:divisions]).to be_an_instance_of(Array)
      expect(subject[:divisions].length).to eq 4
    end
    it '#divisions' do
      expect(subject[:divisions].first[:name]).to eq "AFC East"
      expect(subject[:divisions].first[:id]).to eq "AFC_EAST"
      expect(subject[:divisions].first[:teams]).to be_an_instance_of(Array)
      expect(subject[:divisions].first[:teams].length).to eq 4
    end
    it '#teams' do
      @pats = subject[:divisions].first[:teams].first
      expect(@pats[:id]).to eq "NE"
      expect(@pats[:name]).to eq "Patriots"
      expect(@pats[:market]).to eq "New England"
    end
    it '#overall' do
      @pats = subject[:divisions].first[:teams].first
      expect(@pats[:overall]).to be_an_instance_of(Hash)
      expect(@pats[:overall][:wins]).to eq 12
      expect(@pats[:overall][:losses]).to eq 4
      expect(@pats[:overall][:ties]).to eq 0
      expect(@pats[:overall][:winning_percentage]).to eq 0.75
    end
    it '#in_conference' do
      @pats = subject[:divisions].first[:teams].first
      expect(@pats[:in_conference]).to be_an_instance_of(Hash)
      expect(@pats[:in_conference][:wins]).to eq 9
      expect(@pats[:in_conference][:losses]).to eq 3
      expect(@pats[:in_conference][:ties]).to eq 0
      expect(@pats[:in_conference][:winning_percentage]).to eq 0.75
    end
    it '#non_conference' do
      @pats = subject[:divisions].first[:teams].first
      expect(@pats[:non_conference]).to be_an_instance_of(Hash)
      expect(@pats[:non_conference][:wins]).to eq 3
      expect(@pats[:non_conference][:losses]).to eq 1
      expect(@pats[:non_conference][:ties]).to eq 0
      expect(@pats[:non_conference][:winning_percentage]).to eq 0.75
    end
    it '#in_division' do
      @pats = subject[:divisions].first[:teams].first
      expect(@pats[:in_division]).to be_an_instance_of(Hash)
      expect(@pats[:in_division][:wins]).to eq 4
      expect(@pats[:in_division][:losses]).to eq 2
      expect(@pats[:in_division][:ties]).to eq 0
      expect(@pats[:in_division][:winning_percentage]).to eq 0.667
    end
    it '#grass' do
      @pats = subject[:divisions].first[:teams].first
      expect(@pats[:grass]).to be_an_instance_of(Hash)
      expect(@pats[:grass][:wins]).to eq 9
      expect(@pats[:grass][:losses]).to eq 2
      expect(@pats[:grass][:ties]).to eq 0
      expect(@pats[:grass][:winning_percentage]).to eq 0.818
    end
    it '#turf' do
      @pats = subject[:divisions].first[:teams].first
      expect(@pats[:turf]).to be_an_instance_of(Hash)
      expect(@pats[:turf][:wins]).to eq 3
      expect(@pats[:turf][:losses]).to eq 2
      expect(@pats[:turf][:ties]).to eq 0
      expect(@pats[:turf][:winning_percentage]).to eq 0.6
    end
    it '#scored_first' do
      @pats = subject[:divisions].first[:teams].first
      expect(@pats[:scored_first]).to be_an_instance_of(Hash)
      expect(@pats[:scored_first][:wins]).to eq 6
      expect(@pats[:scored_first][:losses]).to eq 1
      expect(@pats[:scored_first][:ties]).to eq 0
    end
    it '#decided_by_7_points' do
      @pats = subject[:divisions].first[:teams].first
      expect(@pats[:decided_by_7_points]).to be_an_instance_of(Hash)
      expect(@pats[:decided_by_7_points][:wins]).to eq 7
      expect(@pats[:decided_by_7_points][:losses]).to eq 4
      expect(@pats[:decided_by_7_points][:ties]).to eq 0
    end
    it '#leading_at_half' do
      @pats = subject[:divisions].first[:teams].first
      expect(@pats[:leading_at_half]).to be_an_instance_of(Hash)
      expect(@pats[:leading_at_half][:wins]).to eq 7
      expect(@pats[:leading_at_half][:losses]).to eq 2
      expect(@pats[:leading_at_half][:ties]).to eq 0
    end
    it '#last_5' do
      @pats = subject[:divisions].first[:teams].first
      expect(@pats[:last_5]).to be_an_instance_of(Hash)
      expect(@pats[:last_5][:wins]).to eq 4
      expect(@pats[:last_5][:losses]).to eq 1
      expect(@pats[:last_5][:ties]).to eq 0
    end
    it '#points' do
      @pats = subject[:divisions].first[:teams].first
      expect(@pats[:points]).to be_an_instance_of(Hash)
      expect(@pats[:points][:for]).to eq 444
      expect(@pats[:points][:against]).to eq 338
      expect(@pats[:points][:net]).to eq 106
    end
    it '#streak' do
      @pats = subject[:divisions].first[:teams].first
      expect(@pats[:streak]).to be_an_instance_of(Hash)
      expect(@pats[:streak][:type]).to eq "win"
      expect(@pats[:streak][:length]).to eq 2
    end
  end
end
