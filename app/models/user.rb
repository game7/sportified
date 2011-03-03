class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_save :capture_site_at_sign_in

  field :name
  key :name
  index :email, :unique => true
  references_and_referenced_in_many :sites

  validates_presence_of :name
  validates_uniqueness_of :email, :case_sensitive => false

  attr_accessible :name, :email, :password, :password_confirmation
  
  class << self
    def for_site(s)
      id = s.class.to_s == "Site" ? s.id : s
      where(:site_ids => id)
    end
  end

  protected

    def capture_site_at_sign_in
       capture_site if self.sign_in_count_changed?
    end

    def capture_site
      if Site.current
        self.site_ids << Site.current.id unless site_ids.include?(Site.current.id)
      end
    end

    def password_required?
      !persisted? || password.present? || password_confirmation.present?
    end

end
