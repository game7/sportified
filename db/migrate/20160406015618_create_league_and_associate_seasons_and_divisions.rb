class CreateLeagueAndAssociateSeasonsAndDivisions < ActiveRecord::Migration

  def up
    create_and_assign_league 'oceanside', 'OAHL'
    create_and_assign_league 'styfl', 'STYFL'
  end

  def down
    update("update seasons set program_id = null")
    update("update divisions set program_id = null")
    delete("delete from programs")
    League::Program.unscoped.all.each{|league| league.destroy }
  end

  private

  def create_and_assign_league(tenant_slug, league_name)
    id = insert "insert into programs (name, type, created_at, updated_at) values ('#{league_name}','League','#{Time.now}','#{Time.now}')"
    update("update seasons set league_id = #{id}")
    update("update divisions set league_id = #{id}")
  end


end
