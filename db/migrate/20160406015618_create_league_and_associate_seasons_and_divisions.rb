class CreateLeagueAndAssociateSeasonsAndDivisions < ActiveRecord::Migration

  def up
    create_and_assign_league 'oceanside', 'OAHL'
    create_and_assign_league 'styfl', 'STYFL'
  end

  def down
    Season.unscoped.update_all("league_id = null")
    Division.unscoped.update_all("league_id = null")
    League.unscoped.all.each{|league| league.destroy }
  end

  private

  def create_and_assign_league(tenant_slug, league_name)
    Tenant.current = Tenant.find_by(slug: tenant_slug)
    league = League.create(name: league_name);
    Season.update_all("league_id = #{league.id}")
    Division.update_all("league_id = #{league.id}")
  end


end
