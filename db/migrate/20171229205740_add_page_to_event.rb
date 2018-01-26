class AddPageToEvent < ActiveRecord::Migration[5.0]
  def change
    add_reference :events, :page, foreign_key: true
  end
end
