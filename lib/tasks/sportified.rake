namespace :sportified do

  desc "Normalize Event Times"
  task normalize_event_times: :environment do
    Tenant.all.each do |tenant|
      Tenant.current = tenant
      Event.all.each do |event|
        event.starts_on = ActiveSupport::TimeZone.new('Arizona').local_to_utc(event.starts_on)
        event.save_without_auditing
      end
    end
  end

  desc "Normalize All Day Event Times"
  task normalize_allday_event_times: :environment do
    Tenant.all.each do |tenant|
      Tenant.current = tenant
      Event.where(all_day: true).each do |event|
        event.starts_on = ActiveSupport::TimeZone.new('Arizona').local_to_utc(event.starts_on).in_time_zone('Arizona')
        Time.use_zone('Arizona') { event.save_without_auditing }
      end
    end
  end

end