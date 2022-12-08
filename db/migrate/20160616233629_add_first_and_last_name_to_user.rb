class AddFirstAndLastNameToUser < ActiveRecord::Migration[4.2]
  def up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    User.unscoped.each do |user|
      parts = user.name.split(' ')
      user.first_name = parts[0]
      user.last_name = parts[1]
      user.save
    end
    remove_column :users, :name
  end

  def down
    add_column :users, :name, :string
    User.unscoped.each do |user|
      user.name = "#{user.first_name} #{user.last_name}"
      user.save
    end
    remove_column :users, :first_name
    remove_column :users, :last_name
  end
end
