class User
  include Mongoid::Document
  include Mongoid::Timestamps
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, 
          :recoverable, :rememberable, :trackable, :validatable,
          :omniauthable

  before_create :set_id
  before_save :capture_site_at_sign_in

  field :name
  key :name
  index :email
  
  references_and_referenced_in_many :sites
  embeds_many :roles, :class_name => "UserRole"

  embeds_many :authentications

  validates_presence_of :name, :email
  validates_uniqueness_of :name, :email, :case_sensitive => false

  attr_accessible :name, :email, :password, :password_confirmation

  scope :with_email, lambda { |email| { :where => { :email => email } } }

  def role?(role)
    return !!(self.roles.find_by_name(role.to_s).first)
  end
 
  class << self
    def for_site(s)
      id = s.class.to_s == "Site" ? s.id : s
      where(:site_ids => id)
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

    def capture_site_at_sign_in
       capture_site if self.sign_in_count_changed?
    end

    def capture_site
      if Site.current
        self.site_ids ||= []
        self.site_ids << Site.current.id unless site_ids.include?(Site.current.id)
      end
    end

    def password_required?
      !persisted? || password.present? || password_confirmation.present?
    end

end
