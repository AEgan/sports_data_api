require 'spec_helper'

describe SportsDataApi::Nhl::Standings, vcr: {
    cassette_name: 'sports_data_api_nhl_standings',
    record: :new_episodes,
    match_requests_on: [:host, :path]
} do
  let(:standings) do
    SportsDataApi.set_key(:nhl, api_key(:nhl))
    SportsDataApi.set_access_level(:nhl, 't')
    SportsDataApi::Nhl.standings(2013, :REG)
  end
  let(:blues) { standings.west[:divisions].first[:teams].first }
  context 'results from standings fetch' do
    subject { standings }
    it { should be_an_instance_of(SportsDataApi::Nhl::Standings) }
    its(:year) { should eq "2013" }
    its(:type) { should eq "REG" }
    its(:east) { should be_an_instance_of(Hash) }
    its(:west) { should be_an_instance_of(Hash) }
  end
  context 'results from standings : East' do
    subject { standings.east }

    it '#name' do
      expect(subject[:name]).to eq "EASTERN CONFERENCE"
      expect(subject[:alias]).to eq "EASTERN"
    end
    it '#conferences' do
      expect(subject[:divisions]).to be_an_instance_of(Array)
      expect(subject[:divisions].length).to eq 2
    end
    it '#divisions' do
      expect(subject[:divisions].first[:name]).to eq "Atlantic"
      expect(subject[:divisions].first[:alias]).to eq "ATLANTIC"
      expect(subject[:divisions].first[:teams]).to be_an_instance_of(Array)
      expect(subject[:divisions].first[:teams].length).to eq 8
    end
  end
  describe '#blues' do
    it '#id' do
      expect(blues[:id]).to eq "441660ea-0f24-11e2-8525-18a905767e44"
    end
    it '#name' do
      expect(blues[:name]).to eq "Blues"
    end
    it '#market' do
      expect(blues[:market]).to eq "St. Louis"
    end
    it '#games_played' do
      expect(blues[:games_played]).to eq 82
    end
    it '#wins' do
      expect(blues[:wins]).to eq 52
    end
    it '#losses' do
      expect(blues[:losses]).to eq 23
    end
    it '#overtime_losses' do
      expect(blues[:overtime_losses]).to eq 7
    end
    it '#win_pct' do
      expect(blues[:win_pct]).to eq 0.634
    end
    it '#' do
      expect(blues[:points]).to eq 111
    end
    it '#' do
      expect(blues[:regulation_wins]).to eq 43
    end
    it '#shootout_wins' do
      expect(blues[:shootout_wins]).to eq 9
    end
    it '#shootout_losses' do
      expect(blues[:shootout_losses]).to eq 3
    end
    it '#goals_for' do
      expect(blues[:goals_for]).to eq 248
    end
    it '#goals_against' do
      expect(blues[:goals_against]).to eq 191
    end
    it '#goal_diff' do
      expect(blues[:goal_diff]).to eq 57
    end
    it '#powerplays' do
      expect(blues[:powerplays]).to eq 0
    end
    it '#powerplay_goals' do
      expect(blues[:powerplay_goals]).to eq 0
    end
    it '#powerplay_pct' do
      expect(blues[:powerplay_pct]).to eq 0.0
    end
    it '#powerplays_against' do
      expect(blues[:powerplays_against]).to eq 0
    end
    it '#powerplay_goals_against' do
      expect(blues[:powerplay_goals_against]).to eq 0
    end
    it '#penalty_killing_pct' do
      expect(blues[:penalty_killing_pct]).to eq 0
    end
    it '#records' do
      expect(blues[:records]).to be_an_instance_of(Hash)
      expect(blues[:records][:atlantic]).to be_an_instance_of(Hash)
      expect(blues[:records][:central]).to be_an_instance_of(Hash)
      expect(blues[:records][:conference]).to be_an_instance_of(Hash)
      expect(blues[:records][:division]).to be_an_instance_of(Hash)
      expect(blues[:records][:home]).to be_an_instance_of(Hash)
      expect(blues[:records][:last_10]).to be_an_instance_of(Hash)
      expect(blues[:records][:last_10_home]).to be_an_instance_of(Hash)
      expect(blues[:records][:last_10_road]).to be_an_instance_of(Hash)
      expect(blues[:records][:metropolitan]).to be_an_instance_of(Hash)
      expect(blues[:records][:pacific]).to be_an_instance_of(Hash)
      expect(blues[:records][:road]).to be_an_instance_of(Hash)
    end

    it '#atlantic' do
      expect(blues[:records][:atlantic][:wins]).to eq 12
      expect(blues[:records][:atlantic][:losses]).to eq 2
      expect(blues[:records][:atlantic][:overtime_losses]).to eq 2
      expect(blues[:records][:atlantic][:winning_percentage]).to eq 0.75
    end

    it '#home' do
      expect(blues[:records][:home][:wins]).to eq 28
      expect(blues[:records][:home][:losses]).to eq 9
      expect(blues[:records][:home][:overtime_losses]).to eq 4
      expect(blues[:records][:home][:winning_percentage]).to eq 0.683
    end

  end
end
