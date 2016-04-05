# == Schema Information
#
# Table name: seasons
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  slug       :string(255)
#  starts_on  :date
#  tenant_id  :integer
#  mongo_id   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Season < ActiveRecord::Base
  include Sportified::TenantScoped

  validates_presence_of :name, :starts_on

  has_and_belongs_to_many :divisions
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
