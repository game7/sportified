class CreateLeagueEvents < ActiveRecord::Migration
  def up
    Event.unscoped.where(type: nil).update_all(type: 'League::Event')
  end
  def down
    Event.unscoped.where(type: 'League::Event').update_all(type: nil)
  end
end
