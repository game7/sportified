class Player
  include Mongoid::Document
  
  field :first_name
  field :last_name
  field :jersey_number

  field :slug

  referenced_in :team

  before_save :set_slug

  def full_name
    [first_name, last_name].join(' ')
  end

  private

    def set_slug
      self.slug = full_name.parameterize
    end

end
