class EditGameResultForm
  include ActiveModel::Model

  def self.attribute_names
    %w[
      home_team_score
      away_team_score
      result
      completion
      exclude_from_team_records
    ]
  end

  def attributes
    EditGameResultForm.attribute_names.index_with { |k| send(k) }
  end

  def initialize(game)
    @game = game
    assign_attributes game.attributes.slice(*EditGameResultForm.attribute_names)
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, 'League::Game')
  end

  def persisted?
    true
  end

  attr_accessor(*EditGameResultForm.attribute_names)

  validates_presence_of :home_team_score,
                        :away_team_score,
                        :result,
                        :completion

  validates_numericality_of :home_team_score, :away_team_score,
                            only_integer: true

  def submit(params)
    assign_attributes(params)
    return false unless valid?

    @game.update(attributes)
    @game.save
  end
end
