class Team
  include Mongoid::Document

  attr_accessible :_id, :name, :short_name
  
  field :name
  field :short_name
  field :slugs, :type => Array
  field :breadcrumbs, :type => Array

  referenced_in :season, :inverse_of => :teams
  references_many :players  
  references_many :games, :inverse_of => :home_team
  references_many :games, :inverse_of => :away_team

  before_save :set_slugs_and_breadcrumbs
  before_save :ensure_short_name

  scope :with_slugs, lambda { |slugs| all_in(:slugs => slugs) }

  private

    def ensure_short_name
      if self.short_name.nil? || self.short_name.empty?
        self.short_name = self.name
      end
    end

    def set_slugs_and_breadcrumbs
      @parent = self.season
      self.slugs = @parent.slugs << self.name.parameterize
      self.breadcrumbs = @parent.breadcrumbs << { :controller => "teams", :id => self.id, :name => self.name, :slug => self.slugs.last }
    end

end
