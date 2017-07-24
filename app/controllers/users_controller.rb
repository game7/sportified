# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  mongo_id               :string
#  created_at             :datetime
#  updated_at             :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  first_name             :string
#  last_name              :string
#

require 'icalendar'

class UsersController < ApplicationController

  before_action :authenticate_user!, except: [ :schedule ]

  def schedule
    @user = params[:id] ? User.find(params[:id]) : current_user
    team_ids = Player.where(email: @user.email).collect{|p| p.team_id}
    @games = League::Game.where('home_team_id IN (?) OR away_team_id IN (?)', team_ids, team_ids)
                         .order(:starts_on)
                         .includes(:location, :home_team, :away_team)

    respond_to do |format|
      format.html { @games = @games.in_the_future }
      format.ics { to_ical(@user, @games) }
    end

  end

  def subscribe
    ::UserMailer.subscribe(Tenant.current, current_user).deliver
    redirect_to(user_schedule_path, notice: "An email containing a subscription link has been sent to #{current_user.email}")
  end

  private

  def to_ical(user, events)
    cal = Icalendar::Calendar.new
    #offset = ActiveSupport::TimeZone.new('America/Arizona').utc_offset()
    events.each do |e|
      event = Icalendar::Event.new
      event.uid = "#{Tenant.current.name.parameterize}-#{e.id}"
      event.dtstart = e.starts_on.in_time_zone("America/Phoenix") + 7.hours
      event.dtend = e.ends_on.in_time_zone("America/Phoenix") + 7.hours
      event.summary = e.summary
      event.location = e.location&.name
      cal.add_event event
    end
    cal.x_wr_calname = "#{Tenant.current.name} Schedule for #{user.full_name}"
    cal.publish
    filename = "#{Tenant.current.name.parameterize}_#{user.first_name.parameterize}_#{user.last_name.parameterize}_schedule.ics"
    send_data(cal.to_ical, :type => 'text/calendar', :disposition => "inline; filename=#{filename}", :filename => filename)
  end

end
