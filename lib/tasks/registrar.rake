namespace :registrar do

  desc "Purge all registrar data"
  task purge: :environment do
    Registrar::Registrable.unscoped.all.each{ |r| r.destroy }
  end

end
