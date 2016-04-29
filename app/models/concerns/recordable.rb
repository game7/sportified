require 'active_support/concern'

module Concerns
  module Recordable
    extend ActiveSupport::Concern

    included do
      before_create :reset_record
    end

    def streak
     self.last_result + self.current_run.to_s if self.last_result
    end

    def calculate_record
     self.reset_record
     games.order(:starts_on).each do |game|

       # only process games that are final
       next unless game.result.final?

       # don't count if exluded from recrods
       next if game.exclude_from_team_records?

       # determine score
       if self.id == game.home_team_id
         we_scored = game.home_team_score
         they_scored = game.away_team_score
       else
         we_scored = game.away_team_score
         they_scored = game.home_team_score
       end

       self.games_played += 1

       # process win, loss, tie
       if we_scored > they_scored
         result = 'W'
         self.wins += 1
         self.overtime_wins += 1 if game.completion.overtime?
         self.shootout_wins += 1 if game.completion.shootout?
         self.forfeit_wins += 1 if game.completion.forfeit?
         self.points += 2
       elsif they_scored > we_scored
         result = 'L'
         self.losses += 1 unless game.completion.overtime? or game.completion.shootout?
         self.overtime_losses += 1 if game.completion.overtime?
         self.shootout_losses += 1 if game.completion.shootout?
         self.forfeit_losses += 1 if game.completion.forfeit?
         self.points += 1 if game.completion.overtime? || game.completion.shootout?
       else
         result = 'T'
         self.ties += 1
       end

       if self.last_result == result
         self.current_run += 1
       else
         self.last_result = result
         self.current_run = 1
       end

       self.longest_win_streak = self.current_run if result = 'W' && self.current_run > self.longest_win_streak
       self.longest_loss_streak = self.current_run if result = 'L' && self.current_run > self.longest_loss_streak

       self.percent = self.wins.fdiv(self.games_played)
       self.scored += we_scored
       self.allowed += they_scored
       self.margin += (we_scored - they_scored)

     end
    end

    def reset_record
     self.games_played = 0
     self.wins = 0
     self.losses = 0
     self.ties = 0
     self.overtime_wins = 0
     self.overtime_losses = 0
     self.shootout_wins = 0
     self.shootout_losses = 0
     self.forfeit_wins = 0
     self.forfeit_losses = 0
     self.points = 0
     self.percent = 0.00
     self.scored = 0
     self.allowed = 0
     self.margin = 0
     self.last_result = ''
     self.current_run = 0
     self.longest_win_streak = 0
     self.longest_loss_streak = 0
    end
  end
end
