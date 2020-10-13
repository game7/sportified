# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime
#  updated_at             :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  first_name             :string
#  last_name              :string
#  stripe_customer_id     :string
#  unconfirmed_email      :string
#  tenant_id              :bigint(8)        not null
#  admin                  :boolean
#  operations             :boolean
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email_and_tenant_id   (email,tenant_id) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_tenant_id             (tenant_id)
#

class User < ActiveRecord::Base
  include Sportified::TenantScoped
  
  validates :email, presence: true

  passwordless_with :email # <-- here!

  has_and_belongs_to_many :tenants
  has_many :authentications
  has_many :registrations

  scope :with_email, ->(email) { where(:email => email) }

  def host?
    ENV['SUPER_ADMINS'].split(';').include?(self.email)
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  class << self
    def find_by_auth_provider_and_uid(provider, uid)
      where("authentications.provider" => provider, "authentications.uid" => uid).first
    end

    def fetch_resource_for_passwordless(email)
      find_or_create_by(email: email.downcase)
    end
  end

  protected

    def password_required?
      !persisted? || password.present? || password_confirmation.present?
    end

end
