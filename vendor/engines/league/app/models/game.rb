
class Game
  include Mongoid::Document
  include Mongoid::StateMachine
  include Sportified::SiteContext
  include Sportified::PublishesMessages

  field :state
  state_machine :initial => :pending
  state :pending
  state :active
  state :completed
  state(:final, :enter => :enter_final, :exit => :exit_final)

  event :start do
    transitions :to => :active, :from => :pending
  end
  event :complete do
    transitions :to => :completed, :from => [:pending,:active,:final]
  end
  event :finalize do
    transitions :to => :final, :from => [:completed, :active, :pending], :guard => :has_result?
  end

  def available_actions(state = nil)
    state ||= self.state
    result = []
    self.class.read_inheritable_attribute(:transition_table).each do |key, event|
      event.each do |t|
        if t.from == state.to_s
          result << key.to_s
          break
        end
      end
    end
    result
  end

  def available_transitions(state = nil)
    state ||= self.state
    result = []
    self.class.read_inheritable_attribute(:transition_table).each do |key, event|
      event.each do |t|
        if ([] << t.from).index(state.to_s)
          result << [t.to.humanize, key.to_s]
          break
        end
      end
    end
    result
  end

  field :starts_on, :type => DateTime
  field :duration, :type => Integer, :default => 75
  validates_presence_of :duration
  validates_numericality_of :duration, :only_integer => true

  field :ends_on, :type => DateTime
  
  before_save :set_ends_on
  def set_ends_on
    self.ends_on = self.starts_on.advance(:minutes => self.duration)
  end

  referenced_in :season
  
  referenced_in :left_team, :class_name => "Team"
  field :left_custom_name, :type => Boolean
  field :left_team_name
  field :left_team_score, :type => Integer, :default => 0
  validates_numericality_of :left_team_score, :only_integer => true
  def left_team_is_winner?
    return left_team_score > right_team_score
  end

  referenced_in :right_team, :class_name => "Team"
  field :right_team_name
  field :right_custom_name, :type => Boolean
  field :right_team_score, :type => Integer, :default => 0
  validates_numericality_of :right_team_score, :only_integer => true
  def right_team_is_winner?
    return left_team_score < right_team_score
  end

  referenced_in :venue
  field :venue_name
  field :venue_short_name
  before_save do |game|
    venue = game.venue
    game.venue_name = venue ? venue.name : ''
    game.venue_short_name = venue ? venue.short_name : ''
  end

  COMPLETED_IN = %w[regulation overtime shootout forfeit]
  def self.completed_in_options
    COMPLETED_IN.collect{|o| [o.humanize, o] }
  end
  field :completed_in

  referenced_in :statsheet

  validates_presence_of :starts_on, :season_id

  scope :in_the_past, :where => { :starts_on.lt => DateTime.now }
  scope :in_the_future, :where => { :starts_on.gt => DateTime.now }
  scope :from, lambda { |from| { :where => { :starts_on.gt => from } } }
  scope :to, lambda { |to| { :where => { :starts_on.lt => to } } }
  scope :between, lambda { |from, to| { :where => { :starts_on.gt => from, :starts_on.lt => to } } }

  def opponent_id(team_id)
    team_id == self.left_team_id ? self.right_team_id : self.left_team_id
  end

  def opponent_name(team_id)
    team_id == self.left_team_id ? self.right_team_name : self.left_team_name
  end

  def opponent(team_id)
    team_id == self.left_team_id ? self.right_team : self.left_team
  end

  class << self  
    def for_team(t)
      id = t.class == Team ? t.id : t
      any_of( { "left_team_id" => id }, { "right_team_id" => id } )
    end
    def for_season(s)
      id = s.class == Season ? s.id : s
      where(:season_id => id)
    end
    def for_division(d)
      # TODO: perhaps map-reduce would be useful here
      division = d.class == Division ? d : Division.find(d)
      team_ids = division.teams.collect{|team| team.id}
      any_of( { :left_team_id.in => team_ids }, { :right_team_id.in => team_ids })
    end
  end

  before_save :update_team_names

  def has_result?
    self.completed_in.present?
  end

  def display_score?
    self.active? || self.completed? || self.final?
  end

  def has_statsheet?
    !self.statsheet_id.nil?
  end

  def can_add_statsheet?
    !self.has_statsheet? && self.starts_on < DateTime.now
  end

  private

    def update_team_names
      if self.left_team
        self.left_team_name = self.left_team.name unless left_custom_name
      else
        self.left_team_name = '' unless left_custom_name
      end
      if self.right_team
        self.right_team_name = self.right_team.name unless right_custom_name
      else
        self.right_team_name = '' unless right_custom_name
      end
    end

    def enter_final
      msg = Message.new(:game_finalized)
      msg.data[:game_id] = self.id
      enqueue_message msg
    end

    def exit_final
      msg = Message.new(:game_unfinalized)
      msg.data[:game_id] = self.id
      enqueue_message msg
    end

end
