class Admin::Events::LockerRoomsController < ApplicationController
  def assign
    @date = date = params[:date] ? Date.parse(params[:date]) : Date.today
    events = Event.after(date.beginning_of_day)
                  .before(date.end_of_day)
                  .order(:starts_on)
    locker_rooms = LockerRoom.order(:name)
                             .group_by(&:location_id)
                             .transform_values{|v| v.each_slice(v.count/2).to_a}
    events.each do |event|
      event.away_team_locker_room = locker_rooms[event.location_id][0][0]
      event.home_team_locker_room = locker_rooms[event.location_id][1][0]
      event.save
      locker_rooms[event.location_id][0].rotate!
      locker_rooms[event.location_id][1].rotate!
    end
  end
end
