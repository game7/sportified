class Player
  include Mongoid::Document
  
  field :first_name
  field :last_name
  field :jersey_number

  field :slugs, :type => Array
  field :breadcrumbs, :type => Array

  referenced_in :team, :inverse_of => :players

  before_save :set_slugs_and_breadcrumbs

  scope :with_slugs, lambda { |slugs| all_in(:slugs => slugs) }

  def full_name
    [first_name, last_name].join(' ')
  end

  private

    def set_slugs_and_breadcrumbs
      @parent = self.team
      self.slugs = @parent.slugs << full_name.parameterize
      self.breadcrumbs = @parent.breadcrumbs << { :controller => "players", :id => self.id, :name => self.full_name, :slug => self.slugs.last }
    end

end
