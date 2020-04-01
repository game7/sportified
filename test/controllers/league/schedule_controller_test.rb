require 'test_helper'

class League::ScheduleControllerTest < ActionDispatch::IntegrationTest

  setup do
    Tenant.current = tenants(:hockey_league_site)
  end

  context :index do

    setup do
      league = league_programs(:hockey_league)
      division = league.divisions.first
      get league_schedule_url league_slug: league.slug, division_slug: division.slug
    end

    should "get the page" do
      assert_response :success
    end

    should "display the league/season sub menu" do
      assert_select '#area_navigation'
    end

    should "be titled" do
      assert_select '#page-title', 'Schedule'
    end

  end


end
