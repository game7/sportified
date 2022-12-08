class CreateActivityPrograms < ActiveRecord::Migration[4.2]
  def up
    update("update programs set type = 'Activity::Program' where type = 'Activity'")
  end

  def down
    update("update programs set type = 'Activity' where type = 'Activity::Program'")
  end
end
