class CreateLeagueAndAssociateSeasonsAndDivisions < ActiveRecord::Migration

  def up
    # create_and_assign_league 'oceanside', 'OAHL'
    # create_and_assign_league 'styfl', 'STYFL'
  end

  def down
    update("update seasons set league_id = null")
    update("update divisions set league_id = null")
    delete("delete from programs")
    League::Program.unscoped.all.each{|league| league.destroy }
  end

  private

  def create_and_assign_league(tenant_slug, league_name)
    tenant = Tenant.find_by(slug: tenant_slug)
    id = insert "insert into programs (name, tenant_id, type, created_at, updated_at) values ('#{league_name}','#{tenant.id}', 'League','#{Time.now}','#{Time.now}')"
    update("update seasons set league_id = #{id} where tenant_id=#{tenant.id}")
    update("update divisions set league_id = #{id} where tenant_id=#{tenant.id}")
  end


end
