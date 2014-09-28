require 'spec_helper'

describe SportsDataApi::Nhl::Teams, vcr: {
    cassette_name: 'sports_data_api_nhl_league_hierarchy',
    record: :new_episodes,
    match_requests_on: [:host, :path]
} do
  let(:teams) do
    SportsDataApi.set_key(:nhl, api_key(:nhl))
    SportsDataApi.set_access_level(:nhl, 't')
    SportsDataApi::Nhl.teams
  end

  let(:url) { 'http://api.sportsdatallc.org/nhl-t3/league/hierarchy.xml' }

  let(:flyers_xml) do
    str = RestClient.get(url, params: { api_key: api_key(:nhl) }).to_s
    xml = Nokogiri::XML(str).remove_namespaces!
    xml.xpath('/league/conference/division/team[@alias=\'PHI\']')
  end

  let(:flyers) { SportsDataApi::Nhl::Team.new(flyers_xml) }

  subject { teams }
  its(:conferences) { should eq %w(WESTERN EASTERN).map { |str| str.to_sym } }
  its(:divisions) { should eq %w(PACIFIC CENTRAL ATLANTIC METROPOLITAN).map { |str| str.to_sym } }
  its(:count) { should eq 30 }

  it { subject[:"44179d47-0f24-11e2-8525-18a905767e44"].should eq flyers }

  describe 'meta methods' do
    it { should respond_to :EASTERN }
    it { should respond_to :WESTERN }
    it { should respond_to :eastern }
    it { should respond_to :western }
    it { should respond_to :ATLANTIC }
    it { should respond_to :atlantic }
    it { should respond_to :PACIFIC }

    its(:EASTERN) { should be_a Array }
    its(:WESTERN) { should be_a Array }

    context '#EASTERN' do
      subject { teams.EASTERN }
      its(:count) { should eq 16 }
    end

    context '#eastern' do
      subject { teams.eastern }
      its(:count) { should eq 16 }
    end

    context '#WESTERN' do
      subject { teams.WESTERN }
      its(:count) { should eq 14 }
    end

    context '#western' do
      subject { teams.western }
      its(:count) { should eq 14 }
    end

    context '#pacific' do
      subject { teams.pacific }
      its(:count) { should eq 7 }
      it { should_not include flyers }
    end

    context '#PACIFIC' do
      subject { teams.PACIFIC }
      its(:count) { should eq 7 }
      it { should_not include flyers }
    end

    context '#METROPOLITAN' do
      subject { teams.METROPOLITAN }
      its(:count) { should eq 8 }
      it { should include flyers }
    end

    context '#metropolitan' do
      subject { teams.metropolitan }
      its(:count) { should eq 8 }
      it { should include flyers }
    end
  end
end
