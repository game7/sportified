class ResetAllVariantRegistrationsCounterCaches < ActiveRecord::Migration[5.2]
  def up
    Tenant.all.each do |tenant|
      Tenant.current = tenant
      Variant.all.each do |variant|
        Variant.reset_counters(variant.id, :registrations)
      end      
    end
  end
end
