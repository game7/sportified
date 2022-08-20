class CreateLeagueGames < ActiveRecord::Migration[4.2]
  def up
    Event.unscoped.where(type: 'Game').update_all(type: 'League::Game')
  end
  def down
    Event.unscoped.where(type: 'League::Game').update_all(type: 'Game')
  end
end
