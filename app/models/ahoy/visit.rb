# == Schema Information
#
# Table name: ahoy_visits
#
#  id               :bigint           not null, primary key
#  app_version      :string
#  browser          :string
#  city             :string
#  country          :string
#  device_type      :string
#  ip               :string
#  landing_page     :text
#  latitude         :float
#  longitude        :float
#  os               :string
#  os_version       :string
#  platform         :string
#  referrer         :text
#  referring_domain :string
#  region           :string
#  started_at       :datetime
#  user_agent       :text
#  utm_campaign     :string
#  utm_content      :string
#  utm_medium       :string
#  utm_source       :string
#  utm_term         :string
#  visit_token      :string
#  visitor_token    :string
#  tenant_id        :bigint
#  user_id          :bigint
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
