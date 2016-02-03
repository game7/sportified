# == Schema Information
#
# Table name: players
#
#  id            :integer          not null, primary key
#  tenant_id     :integer
#  team_id       :integer
#  first_name    :string(255)
#  last_name     :string(255)
#  jersey_number :string(255)
#  birthdate     :date
#  email         :string(255)
#  slug          :string(255)
#  mongo_id      :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  substitute    :boolean
#

class Player < ActiveRecord::Base
  include Sportified::TenantScoped
  
  belongs_to :tenant
  belongs_to :team
  has_one :league, through: :team
  has_one :season, through: :team
  
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :team_id, presence: true  

  #embeds_one :record, :class_name => "Hockey::Player::Record"

  before_save :ensure_record
  before_save :set_slug

  def full_name
    [first_name, last_name].join(' ')
  end
  
  def age
    ((Date.today - birthdate) / 365).floor if birthdate
  end
  
  class << self
    def for_league(league)
      league_id = ( league.class == League ? league.id : league )
      where(:league_id => league_id)      
    end
    def for_season(season)
      season_id = ( season.class == Season ? season.id : season )
      where(:season_id => season_id)
    end
  end
  
  def apply_mongo_team_id! team_id
    self.team = Team.unscoped.where(mongo_id: team_id.to_s).first
  end
  
  def apply_mongo_tenant_id! tenant_id
    self.tenant = self.team.tenant if self.team
  end
   
  private

    def set_slug
      self.slug = full_name.parameterize
    end
    
    def ensure_record
      #self.record ||= Hockey::Player::Record.new
    end

end
