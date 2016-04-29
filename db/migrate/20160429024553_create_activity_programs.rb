class CreateActivityPrograms < ActiveRecord::Migration
  def up
    update("update programs set type = 'Activity::Program' where type = 'Activity'")
  end
  def down
    update("update programs set type = 'Activity' where type = 'Activity::Program'")
  end
end
