class Player
  include Mongoid::Document
  
  field :first_name
  field :last_name
  field :jersey_number
  field :birthdate, type: Date
  field :email

  field :slug

  belongs_to :team
  validates :team_id, presence: true
  
  embeds_one :record, :class_name => "Hockey::Player::Record"
  before_save :ensure_record

  before_save :set_slug

  def full_name
    [first_name, last_name].join(' ')
  end
  
  def age
    ((Date.today - birthdate) / 365).floor if birthdate
  end
   

  private

    def set_slug
      self.slug = full_name.parameterize
    end
    
    def ensure_record
      self.record ||= Hockey::Player::Record.new
    end    

end
