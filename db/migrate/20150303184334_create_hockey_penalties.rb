class CreateHockeyPenalties < ActiveRecord::Migration[4.2]
  def change
    create_table :hockey_penalties do |t|
      t.references :tenant, index: true
      t.references :statsheet, index: true

      t.integer :period
      t.integer :minute
      t.integer :second

      t.references :team
      t.references :committed_by
      t.string :infraction
      t.integer :duration
      t.string :severity
      t.string :start_period
      t.integer :start_minute
      t.integer :start_second
      t.string :end_period
      t.integer :end_minute
      t.integer :end_second

      t.string :mongo_id, index: true
      t.timestamps
    end
  end
end
