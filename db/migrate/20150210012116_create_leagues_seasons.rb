class CreateLeaguesSeasons < ActiveRecord::Migration
  def change
    create_table :leagues_seasons do |t|
      t.belongs_to :league, index: true
      t.belongs_to :season, index: true
    end
  end
end
