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

      # subcategory helper to clean up the create_hash function
      def xpath_first(outer_set, path_name)
        outer_set.xpath(path_name).first
      end

      def create_hash(team_xml)
        the_hash = Hash.new
        the_hash[:alias] = team_xml[:id]
        the_hash[:name] = team_xml[:name]
        the_hash[:market] = team_xml[:market]

        the_hash[:first_downs] = first_down_hash(xpath_first(team_xml, 'first_downs'))
        the_hash[:third_down] = x_down_efficiency(xpath_first(team_xml, 'third_down_efficiency'))
        the_hash[:fourth_down] = x_down_efficiency(xpath_first(team_xml, 'fourth_down_efficiency'))
        the_hash[:yards] = yards_hash(xpath_first(team_xml, 'total_yards'), xpath_first(team_xml, 'rushing_yards'))
        the_hash[:passing] = passing_hash(xpath_first(team_xml, 'passing'), xpath_first(team_xml,'passing/yards'))

        return_yards = xpath_first(team_xml, 'return_yards')
        punt_return = xpath_first(return_yards, 'punt_return')
        kickoff_return = xpath_first(return_yards, 'kickoff_return')
        int_return = xpath_first(return_yards, 'int_return')
        the_hash[:returns] = returns_hash(return_yards, punt_return, kickoff_return, int_return)

        the_hash[:kickoffs] = kickoff_hash(xpath_first(team_xml, 'kickoffs'))
        the_hash[:punts] = punts_hash(xpath_first(team_xml, 'punts'))
        the_hash[:penalties] = number_yards_hash(xpath_first(team_xml, 'penalties'))
        the_hash[:fumbles] = fumbles_hash(xpath_first(team_xml, 'fumbles'))
        the_hash[:touchdowns] = touchdowns_hash(xpath_first(team_xml, 'touchdowns'))

        extra_points = xpath_first(team_xml, 'extra_points')
        kicking = xpath_first(extra_points, 'kicking')
        two_points = xpath_first(extra_points, 'two_points')
        the_hash[:extra_points] = extra_points_hash(extra_points, kicking, two_points)
        the_hash[:field_goals] = kicking_hash(xpath_first(team_xml, 'field_goals'))

        the_hash[:redzone_efficiency] = touchdown_efficiency(xpath_first(team_xml, 'redzone_efficiency'))
        the_hash[:goal_efficiency] = touchdown_efficiency(xpath_first(team_xml, 'goal_efficiency'))

        the_hash[:safeties] = team_xml.xpath('safeties').first[:number].to_i
        the_hash[:turnovers] = team_xml.xpath('turnovers').first[:number].to_i
        the_hash[:final_score] = team_xml.xpath('final_score').first.children.first.text.to_i
        the_hash[:possession_time] = team_xml.xpath('possession_time').first.children.first.text

        the_hash
      end

      # getting the passing, rushing, and penalty stats was used multiple
      # times so here it's pulled out into its own method
      def passing_rushing_penalty_children(hash, xml)
        %w(passing rushing penalty).each do |stat|
          hash[stat.to_sym] = xml.xpath(stat).first.children.first.text.to_i
        end
      end

      # gets the first down statistics and puts it in its own hash
      def first_down_hash(stats_xml)
        first_downs = Hash.new
        first_downs[:total] = stats_xml[:total].to_i
        passing_rushing_penalty_children(first_downs, stats_xml)
        first_downs
      end

      # creates a hash for the third or fourth down efficency
      def x_down_efficiency(stats_xml)
        x_down = Hash.new
        x_down[:attempts] = stats_xml[:att].to_i
        x_down[:converted] = stats_xml[:converted].to_i
        x_down[:percent] = stats_xml[:pct].to_f
        passing_rushing_penalty_children(x_down, stats_xml)
        x_down
      end

      # creates a hash for the touchdown efficiency
      def touchdown_efficiency(stats_xml)
        {
          attempts: stats_xml[:att].to_i,
          touchdowns: stats_xml[:td].to_i,
          percentage: stats_xml[:pct].to_f
        }
      end

      # creats a hash for the kicking stats
      def kicking_hash(stats_xml)
        attempts_made(stats_xml).merge({blocked: stats_xml[:blk].to_i})
      end

      # creates a hash for the attemps: value and made: value, which is used
      # for field goals and extra points hashs
      def attempts_made(stats_xml)
        {
          attempts: stats_xml[:att].to_i,
          made: stats_xml[:made].to_i
        }
      end

      # creates a hash for extra points statistics
      def extra_points_hash(extra_points_xml, kicking_xml, two_points_xml)
        overall = attempts_made(extra_points_xml)
        overall[:kicking] = kicking_hash(kicking_xml)
        overall[:two_points] = attempts_made(two_points_xml)
        overall
      end

      # creates a hash for yards gained
      def yards_hash(total_xml, rushing_xml)
        overall = plays_yards_average(total_xml)
        overall[:rushing] = plays_yards_average(rushing_xml)
        overall
      end

      # creates a hash with plays, yards, and average values
      def plays_yards_average(stats_xml)
        {
          plays: stats_xml[:plays].to_i,
          yards: stats_xml[:yds].to_f,
          average: stats_xml[:avg].to_f,
        }
      end

      # creates a hash of return statistics
      def returns_hash(return_xml, punt_xml, kickoff_xml, int_xml)
        {
          total: return_xml[:total].to_i,
          punt: number_yards_hash(punt_xml),
          kickoff: number_yards_hash(kickoff_xml),
          interception: number_yards_hash(int_xml)
        }
      end

      # creates a hash with a number of actions and the number of yards
      # used with returns_hash
      def number_yards_hash(stats_xml)
        {
          number: stats_xml[:number].to_i,
          yards: stats_xml[:yds].to_i
        }
      end

      # creates a hash of touchdowns scored and how they were scored
      def touchdowns_hash(stats_xml)
        { number: stats_xml[:number].to_i }.merge(children_first_text_hash(stats_xml))
      end

      # creates a hash for touchdown statistics for each category
      # a bit less repetitive for each
      def children_first_text_hash(stats_xml)
        return_hash = Hash.new
        %w(passing rushing interception).each do |stat|
          return_hash[stat.to_sym] = stats_xml.xpath(stat).first.children.first.text.to_i
        end
        %w(fumble punt kickoff field_goal).each do |stat|
          return_hash[stat.to_sym] = stats_xml.xpath("#{stat}_return").first.children.first.text.to_i
        end
        return_hash
      end

      # creates a hash of passing statistics
      def passing_hash(stats_xml, passing_yards_xml)
        {
          attempts: stats_xml[:att].to_i,
          completions: stats_xml[:cmp].to_i,
          average: stats_xml[:avg].to_f,
          int: stats_xml[:int].to_i,
          sacks: stats_xml[:sack].to_i,
          yards: {
            net: passing_yards_xml[:net_yds].to_f,
            gross: passing_yards_xml[:gross_yds].to_f,
            sack: passing_yards_xml[:sack_yds].to_f
          }
        }
      end

      # creates a hash of kickoff statistics
      def kickoff_hash(stats_xml)
        {
          number: stats_xml[:number].to_i,
          endzone: stats_xml[:endzone].to_i,
          touchback: stats_xml[:tb].to_i
        }
      end

      # creates a hash of punt statistics
      def punts_hash(stats_xml)
        {
          number: stats_xml[:number].to_i,
          average: stats_xml[:avg].to_f,
          net_average: stats_xml[:net_avg].to_f,
          blocked: stats_xml[:blk].to_i
        }
      end

      # creates a hash of fumble statistics
      def fumbles_hash(stats_xml)
        {
          number: stats_xml[:number].to_i,
          lost: stats_xml[:lost].to_i
        }
      end
    end
  end
end
