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
        @home = create_hash(home_team)
        @away = create_hash(away_team)
      end

      private
      def create_hash(team_xml)
        the_hash = {}
        the_hash[:alias] = team_xml[:id]
        the_hash[:name] = team_xml[:name]
        the_hash[:market] = team_xml[:market]
        first_downs = team_xml.xpath('first_downs').first
        the_hash[:first_downs] = first_down_hash(first_downs)
        third_down = team_xml.xpath('third_down_efficiency').first
        the_hash[:third_down] = x_down_efficiency(third_down)
        fourth_down = team_xml.xpath('fourth_down_efficiency').first
        the_hash[:fourth_down] = x_down_efficiency(fourth_down)

        total_yards = team_xml.xpath('total_yards').first
        rushing_yards = team_xml.xpath('rushing_yards').first
        the_hash[:yards] = yards_hash(total_yards, rushing_yards)

        passing = team_xml.xpath('passing').first
        passing_yards = passing.xpath('yards').first
        the_hash[:passing] = {
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
        return_yards = team_xml.xpath('return_yards').first
        punt_return = return_yards.xpath('punt_return').first
        kickoff_return = return_yards.xpath('kickoff_return').first
        int_return = return_yards.xpath('int_return').first
        the_hash[:returns] = {
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

        kickoffs = team_xml.xpath('kickoffs').first
        the_hash[:kickoffs] = {
          number: kickoffs[:number].to_i,
          endzone: kickoffs[:endzone].to_i,
          touchback: kickoffs[:tb].to_i
        }

        punts = team_xml.xpath('punts').first
        the_hash[:punts] = {
          number: punts[:number].to_i,
          average: punts[:avg].to_f,
          net_average: punts[:net_avg].to_f,
          blocked: punts[:blk].to_i
        }

        penalties = team_xml.xpath('penalties').first
        the_hash[:penalties] = {
          number: penalties[:number].to_i,
          yards: penalties[:yds].to_i
        }

        fumbles = team_xml.xpath('fumbles').first
        the_hash[:fumbles] = {
          number: fumbles[:number].to_i,
          lost: fumbles[:lost].to_i
        }

        touchdowns = team_xml.xpath('touchdowns').first
        the_hash[:touchdowns] = {
          number: touchdowns[:number].to_i,
          passing: touchdowns.xpath('passing').first.children.first.text.to_i,
          rushing: touchdowns.xpath('rushing').first.children.first.text.to_i,
          interception: touchdowns.xpath('interception').first.children.first.text.to_i,
          fumble: touchdowns.xpath('fumble_return').first.children.first.text.to_i,
          punt: touchdowns.xpath('punt_return').first.children.first.text.to_i,
          kickoff: touchdowns.xpath('kickoff_return').first.children.first.text.to_i,
          field_goal: touchdowns.xpath('field_goal_return').first.children.first.text.to_i,
        }

        extra_points = team_xml.xpath('extra_points').first
        kicking = extra_points.xpath('kicking').first
        two_points = extra_points.xpath('two_points').first
        the_hash[:extra_points] = extra_points_hash(extra_points)

        field_goals = team_xml.xpath('field_goals').first
        the_hash[:field_goals] = kicking_hash(field_goals)

        redzone_efficiency = team_xml.xpath('redzone_efficiency').first
        the_hash[:redzone_efficiency] = touchdown_efficiency(redzone_efficiency)
        goal_efficiency = team_xml.xpath('goal_efficiency').first
        the_hash[:goal_efficiency] = touchdown_efficiency(goal_efficiency)

        the_hash[:safeties] = team_xml.xpath('safeties').first[:number].to_i

        the_hash[:turnovers] = team_xml.xpath('turnovers').first[:number].to_i

        the_hash[:final_score] = team_xml.xpath('final_score').first.children.first.text.to_i

        the_hash[:possession_time] = team_xml.xpath('possession_time').first.children.first.text

        the_hash
      end

      def passing_rushing_penalty_children(hash, xml)
        %w(passing rushing penalty).each do |stat|
          hash[stat.to_sym] = xml.xpath(stat).first.children.first.text.to_i
        end
      end

      def first_down_hash(first_down_xml)
        first_downs = {}
        first_downs[:total] = first_down_xml[:total].to_i
        passing_rushing_penalty_children(first_downs, first_down_xml)
        first_downs
      end

      def x_down_efficiency(x_down_xml)
        x_down = {}
        x_down[:attempts] = x_down_xml[:att].to_i
        x_down[:converted] = x_down_xml[:converted].to_i
        x_down[:percent] = x_down_xml[:pct].to_f
        passing_rushing_penalty_children(x_down, x_down_xml)
        x_down
      end

      def touchdown_efficiency(stats_xml)
        {
          attempts: stats_xml[:att].to_i,
          touchdowns: stats_xml[:td].to_i,
          percentage: stats_xml[:pct].to_f
        }
      end

      def kicking_hash(stats_xml)
        attempts_made(stats_xml).merge({blocked: stats_xml[:blk].to_i})
      end

      def attempts_made(stats_xml)
        {
          attempts: stats_xml[:att].to_i,
          made: stats_xml[:made].to_i
        }
      end

      def extra_points_hash(extra_points_xml)
        kicking = extra_points_xml.xpath('kicking').first
        two_points = extra_points_xml.xpath('two_points').first
        overall = attempts_made(extra_points_xml)
        overall[:kicking] = kicking_hash(kicking)
        overall[:two_points] = attempts_made(two_points)
        overall
      end

      def yards_hash(total_xml, rushing_xml)
        overall = plays_yards_average(total_xml)
        overall[:rushing] = plays_yards_average(rushing_xml)
        overall
      end

      def plays_yards_average(stats_xml)
        {
          plays: stats_xml[:plays].to_i,
          yards: stats_xml[:yds].to_f,
          average: stats_xml[:avg].to_f,
        }
      end
    end
  end
end
