class League::Season < ActiveRecord::Base
  include Sportified::TenantScoped

  validates_presence_of :name, :starts_on

  belongs_to :program
  has_and_belongs_to_many :divisions, :order => 'name'
  has_many :teams
  #has_many :events

  class << self
    def most_recent
      where("starts_on < ? ", DateTime.now).order(starts_on: :desc).first
    end
    def latest
      order(starts_on: :desc).first
    end
  end

  scope :with_name, ->(name) { where(:name => name) }
  scope :with_slug, ->(slug) { where(:slug => slug) }

  before_save do |season|
    season.slug = season.name.parameterize
  end
end
