# == Schema Information
#
# Table name: ahoy_visits
#
#  id               :bigint(8)        not null, primary key
#  visit_token      :string
#  visitor_token    :string
#  user_id          :bigint(8)
#  ip               :string
#  user_agent       :text
#  referrer         :text
#  referring_domain :string
#  landing_page     :text
#  browser          :string
#  os               :string
#  device_type      :string
#  country          :string
#  region           :string
#  city             :string
#  latitude         :float
#  longitude        :float
#  utm_source       :string
#  utm_medium       :string
#  utm_term         :string
#  utm_content      :string
#  utm_campaign     :string
#  app_version      :string
#  os_version       :string
#  platform         :string
#  started_at       :datetime
#  tenant_id        :bigint(8)
#
# Indexes
#
#  index_ahoy_visits_on_tenant_id    (tenant_id)
#  index_ahoy_visits_on_user_id      (user_id)
#  index_ahoy_visits_on_visit_token  (visit_token) UNIQUE
#

class Ahoy::Visit < ApplicationRecord
  include Sportified::TenantScoped
  self.table_name = 'ahoy_visits'
  paginates_per 50

  has_many :events, -> { unscope(where: :tenant_id).order(time: :asc) }, class_name: 'Ahoy::Event'
  belongs_to :user, optional: true
end
