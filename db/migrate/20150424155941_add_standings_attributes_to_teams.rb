class AddStandingsAttributesToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :games_played, :integer
    add_column :teams, :wins, :integer
    add_column :teams, :losses, :integer
    add_column :teams, :ties, :integer
    add_column :teams, :overtime_wins, :integer
    add_column :teams, :overtime_losses, :integer
    add_column :teams, :shootout_wins, :integer
    add_column :teams, :shootout_losses, :integer
    add_column :teams, :forfeit_wins, :integer
    add_column :teams, :forfeit_losses, :integer
    add_column :teams, :points, :integer
    add_column :teams, :percent, :float
    add_column :teams, :scored, :integer
    add_column :teams, :allowed, :integer
    add_column :teams, :margin, :integer
    add_column :teams, :last_result, :string
    add_column :teams, :current_run, :integer
    add_column :teams, :longest_win_streak, :integer
    add_column :teams, :longest_loss_streak, :integer
  end
end
