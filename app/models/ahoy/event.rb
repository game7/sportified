# == Schema Information
#
# Table name: ahoy_events
#
#  id         :bigint           not null, primary key
#  name       :string
#  properties :jsonb
#  time       :datetime
#  tenant_id  :bigint
#  user_id    :bigint
#  visit_id   :bigint
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
  self.table_name = 'ahoy_events'

  belongs_to :visit, -> { unscope(where: :tenant_id) }
  belongs_to :user, optional: true

  scope :orphan, -> { where('visit_id NOT IN (SELECT id from ahoy_visits)') }
  scope :exceptions, -> { where_event('exception') }
  scope :on_date, lambda { |date|
    return if date.blank?

    from = DateTime.parse(date)
    to = from + 1.day - 1.second
    where(time: [from..to])
  }
  scope :where_host, ->(host) { where_props({ host: host }) if host.present? }
  scope :where_exception, ->(exception) { where_props({ exception: exception }) if exception.present? }
  scope :where_route, lambda { |route|
    return if route.blank?

    controller, action = route.split('#')
    where_props({ params: { controller: controller, action: action } })
  }
end
