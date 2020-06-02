namespace :registrar do

  desc 'Update Registration Status'
  task update_status: :environment do
    [1, 5].each do |tenant_id|
      Tenant.current = Tenant.find(tenant_id)
      Registration.where(completed_at: nil, cancelled_at: nil, abandoned_at: nil).each do |registration|
        registration.update_status!
      end
    end
  end

  desc "Purge all registrar data"
  task purge: :environment do
    Registrar::Registrable.unscoped.all.each{ |r| r.destroy }
  end

end
