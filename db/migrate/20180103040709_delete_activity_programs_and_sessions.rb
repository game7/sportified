class DeleteActivityProgramsAndSessions < ActiveRecord::Migration[5.0]

  def up
    delete Event, 'Activity::Session'
    delete Program, 'Activity::Program'
  end

  private

    def delete(klass, type)
      selector = klass.unscoped.where('type = ? OR type IS NULL', type)
      puts "About to delete #{selector.count} instances of #{klass.name} with type of #{type}"
      selector.delete_all
    end

end
