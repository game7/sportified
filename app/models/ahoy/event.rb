# == Schema Information
#
# Table name: ahoy_events
#
#  id         :bigint(8)        not null, primary key
#  visit_id   :bigint(8)
#  user_id    :bigint(8)
#  name       :string
#  properties :jsonb
#  time       :datetime
#  tenant_id  :bigint(8)
#
# Indexes
#
#  index_ahoy_events_on_name_and_time  (name,time)
#  index_ahoy_events_on_properties     (properties) USING gin
#  index_ahoy_events_on_tenant_id      (tenant_id)
#  index_ahoy_events_on_user_id        (user_id)
#  index_ahoy_events_on_visit_id       (visit_id)
#

class Ahoy::Event < ApplicationRecord
  include Ahoy::QueryMethods
  include Sportified::TenantScoped
  self.table_name = "ahoy_events"

  belongs_to :visit
  belongs_to :user, optional: true
end
