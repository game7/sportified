# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  admin                  :boolean
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  last_name              :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  operations             :boolean
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string
#  created_at             :datetime
#  updated_at             :datetime
#  stripe_customer_id     :string
#  tenant_id              :bigint           not null
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
  has_many :registrations
  has_many :vouchers

  scope :priviledged, -> { where(admin: true).or(where(operations: true)) }
  scope :latest, -> { order(created_at: :desc) }
  # scope :searchx, ->(term) { where('email LIKE \'%?%\' OR last_name LIKE \'%?%\'', term, term) }
  scope :search, lambda { |term|
    email = arel_table[:email].matches("%#{term}%")
    last_name = arel_table[:last_name].matches("%#{term}%")
    where(email).or(where(last_name))
  }

  def host?
    ENV['SUPER_ADMINS']&.split(';')&.include?(email)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  class << self
    def find_by_auth_provider_and_uid(provider, uid)
      where('authentications.provider' => provider, 'authentications.uid' => uid).first
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
