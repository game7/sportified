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

end
