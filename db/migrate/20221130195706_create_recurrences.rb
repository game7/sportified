class CreateRecurrences < ActiveRecord::Migration[5.2]
  def change
    create_table :recurrences do |t|
      t.boolean :monday
      t.boolean :tuesday
      t.boolean :wednesday
      t.boolean :thursday
      t.boolean :friday
      t.boolean :saturday
      t.boolean :sunday
      t.string :ending
      t.date :ends_on
      t.integer :occurrence_count

      t.timestamps
    end
  end
end
