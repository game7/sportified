namespace :sportified do
  desc 'Normalize Event Times'
  task normalize_event_times: :environment do
    Tenant.all.each do |tenant|
      Tenant.current = tenant
      Event.all.each do |event|
        event.starts_on = ActiveSupport::TimeZone.new('Arizona').local_to_utc(event.starts_on)
        event.save_without_auditing
      end
    end
  end

  desc 'Link User to Registrations'
  task link_registrations: :environment do
    Tenant.all.each do |tenant|
      Tenant.current = tenant
      emails = Registration.select(:email).group(:email).pluck(:email)
      accounts = User.all.pluck(:email)
      diff = emails - accounts
      extra = accounts - emails
      puts '----------------------'
      puts tenant.name
      puts "unique registration emails: #{emails.length}"
      puts "user accounts: #{accounts.length}"
      puts "email w/o account #{diff.length}"
      puts "account w/o email #{extra.length}"
      puts '----------------------'
    end
  end

  desc 'Normalize All Day Event Times'
  task normalize_allday_event_times: :environment do
    Tenant.all.each do |tenant|
      Tenant.current = tenant
      Event.where(all_day: true).each do |event|
        event.starts_on = ActiveSupport::TimeZone.new('Arizona').local_to_utc(event.starts_on).in_time_zone('Arizona')
        Time.use_zone('Arizona') { event.save_without_auditing }
      end
    end
  end

  desc 'Dump Production DB to /tmp'
  task dump: :environment do
    config = Rails.configuration.database_configuration['development'].with_indifferent_access
    puts
    if File.exist? '/app/tmp/latest.dump'
      puts 'A local backup exists.  Would you like to capture a new backup? [Y for Yes]'
      puts
      capture_backup = gets.chomp == 'Y'
    else
      capture_backup = true
    end
    if capture_backup
      puts   'Capturing Backup...'
      system 'heroku pg:backups:capture -a sportified4'
      puts   'Downloading Backup...'
      system 'heroku pg:backups:download -a sportified4 -o /app/tmp/latest.dump'
    end
    puts   'Dropping DB...'
    system "PGPASSWORD=#{config[:password]} dropdb -e -h #{config[:host]} -U #{config[:username]} #{config[:database]}"
    puts   'Creating DB...'
    system "PGPASSWORD=#{config[:password]} createdb -e -h #{config[:host]} -U #{config[:username]} #{config[:database]}"
    puts   'Restoring Backup...'
    system "PGPASSWORD=#{config[:password]} pg_restore --no-acl --no-owner -h #{config[:host]} -U #{config[:username]} -d #{config[:database]} /app/tmp/latest.dump"
    puts   'DONE!'

    puts
  end
end
