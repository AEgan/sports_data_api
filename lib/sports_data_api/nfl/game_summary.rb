module SportsDataApi
  module Nfl
    class GameSummary
      attr_reader :home, :away, :id, :scheduled, :status
      # initializes a new game summary with the game xml nokogiri xml element
      def initialize(xml)
        teams = xml.xpath('team')
        home_team = teams.first
        away_team = teams.last
        @id = xml[:id]
        @scheduled = Time.parse xml[:scheduled]
        @status = xml[:status]
        @home = {}
        @away = {}
        # home
        @home[:alias] = home_team[:id]
        @home[:name] = home_team[:name]
        @home[:market] = home_team[:market]
        home_first_downs = home_team.xpath('first_downs').first
        @home[:first_downs] = {
          total: home_first_downs[:total].to_i,
          passing: home_first_downs.xpath('passing').first.children.first.text.to_i,
          rushing: home_first_downs.xpath('rushing').first.children.first.text.to_i,
          penalty: home_first_downs.xpath('penalty').first.children.first.text.to_i,
        }
        third_down = home_team.xpath('third_down_efficiency').first
        @home[:third_down] = {
          attempts: third_down[:att].to_i,
          converted: third_down[:converted].to_i,
          percent: third_down[:pct].to_f,
          passing: third_down.xpath('passing').first.children.first.text.to_i,
          rushing: third_down.xpath('rushing').first.children.first.text.to_i,
          penalty: third_down.xpath('penalty').first.children.first.text.to_i
        }

        fourth_down = home_team.xpath('fourth_down_efficiency').first
        @home[:fourth_down] = {
          attempts: fourth_down[:att].to_i,
          converted: fourth_down[:converted].to_i,
          percent: fourth_down[:pct].to_f,
          passing: fourth_down.xpath('passing').first.children.first.text.to_i,
          rushing: fourth_down.xpath('rushing').first.children.first.text.to_i,
          penalty: fourth_down.xpath('penalty').first.children.first.text.to_i
        }

        total_yards = home_team.xpath('total_yards').first
        rushing_yards = home_team.xpath('rushing_yards').first
        @home[:yards] = {
          plays: total_yards[:plays].to_i,
          yards: total_yards[:yds].to_f,
          average: total_yards[:avg].to_f,
          rushing: {
            plays: rushing_yards[:plays].to_i,
            yards: rushing_yards[:yds].to_i,
            average: rushing_yards[:avg].to_f
          }
        }

        passing = home_team.xpath('passing').first
        passing_yards = passing.xpath('yards').first
        @home[:passing] = {
          attempts: passing[:att].to_i,
          completions: passing[:cmp].to_i,
          average: passing[:avg].to_f,
          int: passing[:int].to_i,
          sacks: passing[:sack].to_i,
          yards: {
            net: passing_yards[:net_yds].to_f,
            gross: passing_yards[:gross_yds].to_f,
            sack: passing_yards[:sack_yds].to_f
          }
        }
        return_yards = home_team.xpath('return_yards').first
        punt_return = return_yards.xpath('punt_return').first
        kickoff_return = return_yards.xpath('kickoff_return').first
        int_return = return_yards.xpath('int_return').first
        @home[:returns] = {
          total: return_yards[:total].to_i,
          punt: {
            number: punt_return[:number].to_i,
            yards: punt_return[:yds].to_i
          },
          kickoff: {
            number: kickoff_return[:number].to_i,
            yards: kickoff_return[:yds].to_i
          },
          interception: {
            number: int_return[:number].to_i,
            yards: int_return[:yds].to_i
          }
        }

        kickoffs = home_team.xpath('kickoffs').first
        @home[:kickoffs] = {
          number: kickoffs[:number].to_i,
          endzone: kickoffs[:endzone].to_i,
          touchback: kickoffs[:tb].to_i
        }

        punts = home_team.xpath('punts').first
        @home[:punts] = {
          number: punts[:number].to_i,
          average: punts[:avg].to_f,
          net_average: punts[:net_avg].to_f,
          blocked: punts[:blk].to_i
        }

        penalties = home_team.xpath('penalties').first
        @home[:penalties] = {
          number: penalties[:number].to_i,
          yards: penalties[:yds].to_i
        }

        fumbles = home_team.xpath('fumbles').first
        @home[:fumbles] = {
          number: fumbles[:number].to_i,
          lost: fumbles[:lost].to_i
        }

        touchdowns = home_team.xpath('touchdowns').first
        @home[:touchdowns] = {
          number: touchdowns[:number].to_i,
          passing: touchdowns.xpath('passing').first.children.first.text.to_i,
          rushing: touchdowns.xpath('rushing').first.children.first.text.to_i,
          interception: touchdowns.xpath('interception').first.children.first.text.to_i,
          fumble: touchdowns.xpath('fumble_return').first.children.first.text.to_i,
          punt: touchdowns.xpath('punt_return').first.children.first.text.to_i,
          kickoff: touchdowns.xpath('kickoff_return').first.children.first.text.to_i,
          field_goal: touchdowns.xpath('field_goal_return').first.children.first.text.to_i,
        }

        extra_points = home_team.xpath('extra_points').first
        kicking = extra_points.xpath('kicking').first
        two_points = extra_points.xpath('two_points').first
        @home[:extra_points] = {
          attempts: extra_points[:att].to_i,
          made: extra_points[:made].to_i,
          kicking: {
            attempts: kicking[:att].to_i,
            made: kicking[:made].to_i,
            blocked: kicking[:blk].to_i
          },
          two_points: {
            attempts: two_points[:att].to_i,
            made: two_points[:made].to_i
          }
        }

        field_goals = home_team.xpath('field_goals').first
        @home[:field_goals] = {
          attempts: field_goals[:att].to_i,
          made: field_goals[:made].to_i,
          blocked: field_goals[:blk].to_i
        }

        redzone_efficiency = home_team.xpath('redzone_efficiency').first
        @home[:redzone_efficiency] = {
          attempts: redzone_efficiency[:att].to_i,
          touchdowns: redzone_efficiency[:td].to_i,
          percentage: redzone_efficiency[:pct].to_f
        }

        goal_efficiency = home_team.xpath('goal_efficiency').first
        @home[:goal_efficiency] = {
          attempts: goal_efficiency[:att].to_i,
          touchdowns: goal_efficiency[:td].to_i,
          percentage: goal_efficiency[:pct].to_f
        }

        @home[:safeties] = home_team.xpath('safeties').first[:number].to_i

        @home[:turnovers] = home_team.xpath('turnovers').first[:number].to_i

        @home[:final_score] = home_team.xpath('final_score').first.children.first.text.to_i

        @home[:possession_time] = home_team.xpath('possession_time').first.children.first.text

        # away
        @away[:alias] = away_team[:id]
        @away[:name] = away_team[:name]
        @away[:market] = away_team[:market]

        away_first_down = away_team.xpath('first_downs').first
        @away[:first_downs] = {
          total: away_first_down[:total].to_i,
          passing: away_first_down.xpath('passing').first.children.first.text.to_i,
          rushing: away_first_down.xpath('rushing').first.children.first.text.to_i,
          penalty: away_first_down.xpath('penalty').first.children.first.text.to_i,
        }
        third_down = away_team.xpath('third_down_efficiency').first
        @away[:third_down] = {
          attempts: third_down[:att].to_i,
          converted: third_down[:converted].to_i,
          percent: third_down[:pct].to_f,
          passing: third_down.xpath('passing').first.children.first.text.to_i,
          rushing: third_down.xpath('rushing').first.children.first.text.to_i,
          penalty: third_down.xpath('penalty').first.children.first.text.to_i
        }

        fourth_down = away_team.xpath('fourth_down_efficiency').first
        @away[:fourth_down] = {
          attempts: fourth_down[:att].to_i,
          converted: fourth_down[:converted].to_i,
          percent: fourth_down[:pct].to_f,
          passing: fourth_down.xpath('passing').first.children.first.text.to_i,
          rushing: fourth_down.xpath('rushing').first.children.first.text.to_i,
          penalty: fourth_down.xpath('penalty').first.children.first.text.to_i
        }

        total_yards = away_team.xpath('total_yards').first
        rushing_yards = away_team.xpath('rushing_yards').first
        @away[:yards] = {
          plays: total_yards[:plays].to_i,
          yards: total_yards[:yards].to_i,
          average: total_yards[:avg].to_f,
          rushing: {
            plays: rushing_yards[:plays].to_i,
            yards: rushing_yards[:yds].to_i,
            average: rushing_yards[:avg].to_f
          }
        }

        passing = home_team.xpath('passing').first
        passing_yards = passing.xpath('yards').first
        @away[:passing] = {
          attempts: passing[:att].to_i,
          completions: passing[:cpt].to_i,
          average: passing[:avg].to_f,
          int: passing[:int].to_i,
          sacks: passing[:sack].to_i,
          yards: {
            net: passing_yards[:net_yds].to_f,
            gross: passing_yards[:gross_yds].to_f,
            sack: passing_yards[:sack_yds].to_f
          }
        }
        return_yards = away_team.xpath('return_yards').first
        punt_return = return_yards.xpath('punt_return').first
        kickoff_return = return_yards.xpath('kickoff_return').first
        int_return = return_yards.xpath('int_return').first
        @away[:returns] = {
          total: return_yards[:total].to_i,
          punt: {
            number: punt_return[:number].to_i,
            yards: punt_return[:yds].to_i
          },
          kickoff: {
            number: kickoff_return[:number].to_i,
            yards: kickoff_return[:yds].to_i
          },
          interception: {
            number: int_return[:number].to_i,
            yards: int_return[:yds].to_i
          }
        }

        kickoffs = away_team.xpath('kickoffs').first
        @away[:kickoffs] = {
          number: kickoffs[:number].to_i,
          endzone: kickoffs[:endzone].to_i,
          touchback: kickoffs[:tb].to_i
        }

        punts = away_team.xpath('punts').first
        @away[:punts] = {
          number: punts[:number].to_i,
          average: punts[:avg].to_f,
          net_average: punts[:net_avg].to_f,
          blocked: punts[:blk].to_i
        }

        penalties = away_team.xpath('penalties').first
        @away[:penalties] = {
          number: penalties[:number].to_i,
          yards: penalties[:yds].to_i
        }

        fumbles = away_team.xpath('fumbles').first
        @away[:fumbles] = {
          number: fumbles[:number].to_i,
          lost: fumbles[:lost].to_i
        }

        touchdowns = away_team.xpath('touchdowns').first
        @away[:touchdowns] = {
          number: touchdowns[:number].to_i,
          passing: touchdowns.xpath('passing').first.children.first.text.to_i,
          rushing: touchdowns.xpath('rushing').first.children.first.text.to_i,
          interception: touchdowns.xpath('interception').first.children.first.text.to_i,
          fumble: touchdowns.xpath('fumble_return').first.children.first.text.to_i,
          punt: touchdowns.xpath('punt_return').first.children.first.text.to_i,
          kickoff: touchdowns.xpath('kickoff_return').first.children.first.text.to_i,
          field_goal: touchdowns.xpath('field_goal_return').first.children.first.text.to_i,
        }

        extra_points = away_team.xpath('extra_points').first
        kicking = extra_points.xpath('kicking').first
        two_points = extra_points.xpath('two_points').first
        @away[:extra_points] = {
          attempts: extra_points[:att].to_i,
          made: extra_points[:made].to_i,
          kicking: {
            attempts: kicking[:att].to_i,
            made: kicking[:made].to_i,
            blocked: kicking[:blk].to_i
          },
          two_points: {
            attempts: two_points[:att].to_i,
            made: two_points[:made].to_i
          }
        }

        field_goals = away_team.xpath('field_goals').first
        @away[:field_goals] = {
          attempts: field_goals[:att].to_i,
          made: field_goals[:made].to_i,
          blocked: field_goals[:blk].to_i
        }

        redzone_efficiency = away_team.xpath('redzone_efficiency').first
        @away[:redzone_efficiency] = {
          attempts: redzone_efficiency[:att].to_i,
          touchdowns: redzone_efficiency[:td].to_i,
          percentage: redzone_efficiency[:pct].to_f
        }

        goal_efficiency = away_team.xpath('goal_efficiency').first
        @away[:goal_efficiency] = {
          attempts: goal_efficiency[:att].to_i,
          touchdowns: goal_efficiency[:td].to_i,
          percentage: goal_efficiency[:pct].to_f
        }

        @away[:safeties] = away_team.xpath('safeties').first[:number].to_i

        @away[:turnovers] = away_team.xpath('turnovers').first[:number].to_i

        @away[:final_score] = away_team.xpath('final_score').first.children.first.text.to_i

        @away[:possession_time] = away_team.xpath('possession_time').first.children.first.text
      end

    end
  end
end
