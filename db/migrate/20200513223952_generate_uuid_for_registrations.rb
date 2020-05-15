class GenerateUuidForRegistrations < ActiveRecord::Migration[5.2]
  def up
    Registration.unscoped.where(uuid: nil).each do |registration|
      registration.update_attribute(:uuid, SecureRandom.uuid)
    end
  end
end
