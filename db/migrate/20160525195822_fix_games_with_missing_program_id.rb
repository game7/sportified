class FixGamesWithMissingProgramId < ActiveRecord::Migration
  def up
    update("update events set program_id = 2 where tenant_id = 5")
  end
end
