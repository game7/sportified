# == Schema Information
#
# Table name: players
#
#  id            :integer          not null, primary key
#  tenant_id     :integer
#  team_id       :integer
#  first_name    :string
#  last_name     :string
#  jersey_number :string
#  birthdate     :date
#  email         :string
#  slug          :string
#  mongo_id      :string
#  created_at    :datetime
#  updated_at    :datetime
#  substitute    :boolean
#  position      :string
#

class Player < ActiveRecord::Base
  include Sportified::TenantScoped

  belongs_to :tenant
  belongs_to :team, class_name: 'League::Team'
  has_one :division, through: :team
  has_one :season, through: :team

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :team_id, presence: true
  validates :position, length: { maximum: 5 }

  #embeds_one :record, :class_name => "Hockey::Player::Record"

  before_save :ensure_record
  before_save :set_slug

  def full_name
    [first_name, last_name].join(' ')
  end

  def last_first
    [last_name, first_name].join(', ')
  end

  def age
    ((Date.today - birthdate) / 365).floor if birthdate
  end

  class << self
    def for_division(division)
      division_id = ( division.class == Division ? division.id : division )
      where(:division_id => division_id)
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
