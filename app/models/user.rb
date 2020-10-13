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
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ActiveRecord::Base

  validates :email, presence: true, uniqueness: { case_sensitive: false }

  passwordless_with :email # <-- here!

  has_and_belongs_to_many :tenants
  has_many :roles, foreign_key: :user_id, class_name: 'UserRole'

  before_save :capture_tenant_at_sign_in

  has_many :roles, :class_name => "UserRole"
  has_many :authentications

  has_many :registrations

  validates_presence_of :email

  scope :with_email, ->(email) { where(:email => email) }

  def admin?(tenant_id)
    self.roles.any? {|r| r.name == 'admin' and r.tenant_id == tenant_id }
  end

  def host?
    self.roles.any? {|r| r.name == 'super_admin' }
  end

  def host_or_admin?(tenant_id)
    host? or admin?(tenant_id)
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  class << self
    def for_tenant(t)
      id = t.class.to_s == "Tenant" ? t.id : t
      joins(:tenants).where(tenants: { id: id })
    end

    def find_by_auth_provider_and_uid(provider, uid)
      where("authentications.provider" => provider, "authentications.uid" => uid).first
    end

    def fetch_resource_for_passwordless(email)
      find_or_create_by(email: email.downcase)
    end
  end

  protected

    def set_id
      self._id = self.name if self._id.blank?
    end

    def capture_tenant_at_sign_in
      capture_tenant if self.sign_in_count_changed?
    end

    def capture_tenant
      unless self.tenants.all.include?(Tenant.current)
        self.tenants << Tenant.current
      end
    end

    def password_required?
      !persisted? || password.present? || password_confirmation.present?
    end

end
