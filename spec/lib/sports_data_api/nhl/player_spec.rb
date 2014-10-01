require 'spec_helper'

describe SportsDataApi::Nhl::Player, vcr: {
    cassette_name: 'sports_data_api_nhl_player',
    record: :new_episodes,
    match_requests_on: [:host, :path]
} do
  before do
    SportsDataApi.set_key(:nhl, api_key(:nhl))
    SportsDataApi.set_access_level(:nhl, 't')
  end

  let(:kings_id) { SportsDataApi::Nhl.teams.first.id }


  let(:roster) { SportsDataApi::Nhl.team_roster(kings_id) }


  let(:pearson) { roster.first }


  let(:king) { roster[2] }


  describe 'pearson' do
    subject { pearson }
    it 'should have an id' do
      expect(subject.id).to eql '3abc026d-b911-11e2-8051-f4ce4684ea4c'
    end

    it 'should have a status' do
      expect(subject.status).to eql 'ACT'
    end

    it 'should have a full_name' do
      expect(subject.full_name).to eql 'Tanner Pearson'
    end

    it 'should have a first_name' do
      expect(subject.first_name).to eql 'Tanner'
    end

    it 'should have a last_name' do
      expect(subject.last_name).to eql 'Pearson'
    end

    it 'should have an abbr_name' do
      expect(subject.abbr_name).to eql 'T.Pearson'
    end

    it 'should have a height' do
      expect(subject.height).to eql '72'
    end

    it 'should have a weight' do
      expect(subject.weight).to eql '193'
    end

    it 'should have a position' do
      expect(subject.position).to eql 'F'
    end

    it 'should have a primary_position' do
      expect(subject.primary_position).to eql 'C'
    end

    it 'should have a jersey_number' do
      expect(subject.jersey_number).to eql '70'
    end

    it 'should have an experience' do
      expect(subject.experience).to eql '1'
    end

    it 'should have a birth_place' do
      expect(subject.birth_place).to eql 'Kitchener, ON, CAN'
    end

    it 'should have a birthdate' do
      expect(subject.birthdate).to eql "1992-08-10"
    end

    it 'should have a draft round' do
      expect(subject.draft_round).to eql "1"
    end

    it 'should have a draft pick' do
      expect(subject.draft_pick).to eql "30"
    end
  end

  describe 'king' do
    subject { king }
    it 'should have an id' do
      expect(subject.id).to eql '427cfba4-0f24-11e2-8525-18a905767e44'
    end

    it 'should have a status' do
      expect(subject.status).to eql 'ACT'
    end

    it 'should have a full_name' do
      expect(subject.full_name).to eql 'Dwight King'
    end

    it 'should have a first_name' do
      expect(subject.first_name).to eql 'Dwight'
    end

    it 'should have a last_name' do
      expect(subject.last_name).to eql 'King'
    end

    it 'should have an abbr_name' do
      expect(subject.abbr_name).to eql 'D.King'
    end

    it 'should have a height' do
      expect(subject.height).to eql '76'
    end

    it 'should have a weight' do
      expect(subject.weight).to eql '230'
    end

    it 'should have a position' do
      expect(subject.position).to eql 'F'
    end

    it 'should have a primary_position' do
      expect(subject.primary_position).to eql 'LW'
    end

    it 'should have a jersey_number' do
      expect(subject.jersey_number).to eql '74'
    end

    it 'should have an experience' do
      expect(subject.experience).to eql '4'
    end

    it 'should have a birth_place' do
      expect(subject.birth_place).to eql 'Meadowlake, SK, CAN'
    end

    it 'should have a birthdate' do
      expect(subject.birthdate).to eql '1989-07-05'
    end

    it 'should have a draft round' do
      expect(subject.draft_round).to eql '4'
    end

    it 'should have a draft pick' do
      expect(subject.draft_pick).to eql '109'
    end
  end

end
