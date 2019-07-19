class DropLoggedExceptions < ActiveRecord::Migration[5.2]
  def up
    drop_table :logged_exceptions
  end
end
