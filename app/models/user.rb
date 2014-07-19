class User
  include Mongoid::Document
  include Mongoid::Timestamps
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, 
          :recoverable, :rememberable, :trackable, :validatable,
          :omniauthable
          
  ## Database authenticatable
  field :email,              :type => String
  validates :email, presence: true
  field :encrypted_password, :type => String
  validates :encrypted_password, presence: true

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String          

  ## Encryptable
  # field :password_salt, :type => String

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  # Token authenticatable
  # field :authentication_token, :type => String

  ## Invitable
  # field :invitation_token, :type => String
  
  before_create :set_id
  before_save :capture_tenant_at_sign_in

  field :name
  
  has_and_belongs_to_many :tenants
  embeds_many :roles, :class_name => "UserRole"

  embeds_many :authentications

  validates_presence_of :name, :email
  validates_uniqueness_of :name, :email, :case_sensitive => false

  scope :with_email, lambda { |email| { :where => { :email => email } } }

  def role?(role)
    return !!(self.roles.find_by_name(role.to_s).first)
  end
 
  class << self
    def for_tenant(t)
      id = t.class.to_s == "Tenant" ? t.id : t
      where(:tenant_ids => id)
    end
    def find_by_auth_provider_and_uid(provider, uid)
      where("authentications.provider" => provider, "authentications.uid" => uid).first
    end
  end

  def apply_omniauth(omniauth)
    self.name = omniauth['user_info']['name'] if name.blank?
    self.email = omniauth['user_info']['email'] if email.blank?
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end

  protected

    def set_id
      self._id = self.name if self._id.blank?
    end

    def capture_tenant_at_sign_in
       capture_tenant if self.sign_in_count_changed?
    end

    def capture_tenant
      if Tenant.current
        self.tenant_ids ||= []
        self.tenant_ids << Tenant.current.id unless tenant_ids.include?(Tenant.current.id)
      end
    end

    def password_required?
      !persisted? || password.present? || password_confirmation.present?
    end

end
