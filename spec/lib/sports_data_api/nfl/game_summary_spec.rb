require 'spec_helper'

describe SportsDataApi::Nfl::Game, vcr: {
    cassette_name: 'sports_data_api_nfl_game_summary',
    record: :new_episodes,
    match_requests_on: [:host, :path]
} do
  let(:game_summary) do
    SportsDataApi.set_key(:nfl, api_key(:nfl))
    SportsDataApi.set_access_level(:nfl, 't')
    SportsDataApi::Nfl.game_summary(2014, :REG, 1, "BUF", "CHI")
  end
  context 'results from game summary fetch' do
    subject { game_summary }
    it { should be_an_instance_of(SportsDataApi::Nfl::GameSummary) }
    its(:home) { should be_an_instance_of(Hash) }
    its(:away) { should be_an_instance_of(Hash) }
    its(:status) { should eq 'closed' }
    its(:scheduled) { should eq Time.new(2014, 9, 7, 13, 00, 00, '-04:00') }
    its(:id) { should eq "eb3bb333-6ae5-417c-b9e3-1d3dfdb8673e" }
  end

  context 'results from game summary fetch (home team)' do
    subject { game_summary.home }
    it '#alias' do
      puts subject.class
      puts subject[:alias]
      expect(subject[:alias]).to eq "CHI"
    end
    it '#name' do
      expect(subject[:name]).to eq "Bears"
    end
    it '#market' do
      expect(subject[:market]).to eq "Chicago"
    end
    it '#first_downs' do
      expect(subject[:first_downs]).to be_an_instance_of(Hash)
      expect(subject[:first_downs][:total]).to eq 29
      expect(subject[:first_downs][:passing]).to eq 19
      expect(subject[:first_downs][:rushing]).to eq 5
      expect(subject[:first_downs][:penalty]).to eq 5
    end
    it '#third_down' do
      expect(subject[:third_down]).to be_an_instance_of(Hash)
      expect(subject[:third_down][:attempts]).to eq 12
      expect(subject[:third_down][:converted]).to eq 5
      expect(subject[:third_down][:percent]).to eq 41.667
      expect(subject[:third_down][:passing]).to eq 4
      expect(subject[:third_down][:rushing]).to eq 1
      expect(subject[:third_down][:penalty]).to eq 0
    end
    it '#fourth_down' do
      expect(subject[:fourth_down]).to be_an_instance_of(Hash)
      expect(subject[:fourth_down][:attempts]).to eq 0
      expect(subject[:fourth_down][:converted]).to eq 0
      expect(subject[:fourth_down][:percent]).to eq 0.0
      expect(subject[:fourth_down][:passing]).to eq 0
      expect(subject[:fourth_down][:rushing]).to eq 0
      expect(subject[:fourth_down][:penalty]).to eq 0
    end
    it '#yards' do
      expect(subject[:yards]).to be_an_instance_of(Hash)
      expect(subject[:yards][:plays]).to eq 69
      expect(subject[:yards][:yards]).to eq 427.0
      expect(subject[:yards][:average]).to eq 6.188
      expect(subject[:yards][:rushing]).to be_an_instance_of(Hash)
      expect(subject[:yards][:rushing][:plays]).to eq 18
      expect(subject[:yards][:rushing][:yards]).to eq 86
      expect(subject[:yards][:rushing][:average]).to eq 4.778
    end
    it '#passing' do
      expect(subject[:passing]).to be_an_instance_of(Hash)
      expect(subject[:passing][:attempts]).to eq 49
      expect(subject[:passing][:completions]).to eq 34
      expect(subject[:passing][:average]).to eq 6.686
      expect(subject[:passing][:int]).to eq 2
      expect(subject[:passing][:sacks]).to eq 2
      expect(subject[:passing][:yards]).to be_an_instance_of(Hash)
      expect(subject[:passing][:yards][:net]).to eq 341.0
      expect(subject[:passing][:yards][:gross]).to eq 349
      expect(subject[:passing][:yards][:sack]).to eq 8.0
    end
    it '#returns' do
      expect(subject[:returns]).to be_an_instance_of(Hash)
      expect(subject[:returns][:total]).to eq 4
      expect(subject[:returns][:punt]).to be_an_instance_of(Hash)
      expect(subject[:returns][:punt][:number]).to eq 1
      expect(subject[:returns][:punt][:yards]).to eq -1
      expect(subject[:returns][:kickoff]).to be_an_instance_of(Hash)
      expect(subject[:returns][:kickoff][:number]).to eq 1
      expect(subject[:returns][:kickoff][:yards]).to eq 21
      expect(subject[:returns][:interception]).to be_an_instance_of(Hash)
      expect(subject[:returns][:interception][:number]).to eq 1
      expect(subject[:returns][:interception][:yards]).to eq 5
    end
    it '#kickoffs' do
      expect(subject[:kickoffs]).to be_an_instance_of(Hash)
      expect(subject[:kickoffs][:number]).to eq 5
      expect(subject[:kickoffs][:endzone]).to eq 4
      expect(subject[:kickoffs][:touchback]).to eq 3
    end
    it '#punts' do
      expect(subject[:punts]).to be_an_instance_of(Hash)
      expect(subject[:punts][:number]).to eq 4
      expect(subject[:punts][:average]).to eq 40.0
      expect(subject[:punts][:net_average]).to eq 36.5
      expect(subject[:punts][:blocked]).to eq 0
    end
    it '#penalties' do
      expect(subject[:penalties]).to be_an_instance_of(Hash)
      expect(subject[:penalties][:number]).to eq 4
      expect(subject[:penalties][:yards]).to eq 43
    end
    it '#fumbles' do
      expect(subject[:fumbles]).to be_an_instance_of(Hash)
      expect(subject[:fumbles][:number]).to eq 1
      expect(subject[:fumbles][:lost]).to eq 1
    end
    it '#touchdowns' do
      expect(subject[:touchdowns]).to be_an_instance_of(Hash)
      expect(subject[:touchdowns][:number]).to eq 2
      expect(subject[:touchdowns][:passing]).to eq 2
      expect(subject[:touchdowns][:rushing]).to eq 0
      expect(subject[:touchdowns][:interception]).to eq 0
      expect(subject[:touchdowns][:interception]).to eq 0
      expect(subject[:touchdowns][:fumble]).to eq 0
      expect(subject[:touchdowns][:punt]).to eq 0
      expect(subject[:touchdowns][:kickoff]).to eq 0
      expect(subject[:touchdowns][:field_goal]).to eq 0
    end
    it '#extra_points' do
      expect(subject[:extra_points]).to be_an_instance_of(Hash)
      expect(subject[:extra_points][:attempts]).to eq 2
      expect(subject[:extra_points][:made]).to eq 2
      expect(subject[:extra_points][:kicking]).to be_an_instance_of(Hash)
      expect(subject[:extra_points][:kicking][:attempts]).to eq 2
      expect(subject[:extra_points][:kicking][:made]).to eq 2
      expect(subject[:extra_points][:kicking][:blocked]).to eq 0
      expect(subject[:extra_points][:two_points]).to be_an_instance_of(Hash)
      expect(subject[:extra_points][:two_points][:attempts]).to eq 0
      expect(subject[:extra_points][:two_points][:made]).to eq 0
    end
    it '#field_goals' do
      expect(subject[:field_goals]).to be_an_instance_of(Hash)
      expect(subject[:field_goals][:attempts]).to eq 2
      expect(subject[:field_goals][:made]).to eq 2
      expect(subject[:field_goals][:blocked]).to eq 0
    end
    it '#redzone_efficiency' do
      expect(subject[:redzone_efficiency]).to be_an_instance_of(Hash)
      expect(subject[:redzone_efficiency][:attempts]).to eq 3
      expect(subject[:redzone_efficiency][:touchdowns]).to eq 2
      expect(subject[:redzone_efficiency][:percentage]).to eq 66.667
    end
    it '#goal_efficiency' do
      expect(subject[:goal_efficiency]).to be_an_instance_of(Hash)
      expect(subject[:goal_efficiency][:attempts]).to eq 0
      expect(subject[:goal_efficiency][:touchdowns]).to eq 0
      expect(subject[:goal_efficiency][:percentage]).to eq 0.0
    end
    it '#safeties' do
      expect(subject[:safeties]).to eq 0
    end
    it '#turnovers' do
      expect(subject[:turnovers]).to eq 3
    end
    it '#final_score' do
      expect(subject[:final_score]).to eq 20
    end
    it '#possession_time' do
      expect(subject[:possession_time]).to eq "34:42"
    end
  end
end
