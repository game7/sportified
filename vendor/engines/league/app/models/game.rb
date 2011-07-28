
class Game < Event
  include Mongoid::StateMachine

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

  COMPLETED_IN = %w[regulation overtime shootout forfeit]
  def self.completed_in_options
    COMPLETED_IN.collect{|o| [o.humanize, o] }
  end
  field :completed_in

  referenced_in :statsheet

  def has_team?(team)
    id = team.class == Team ? team.id : team
    id == left_team_id || id == right_team_id
  end

  def opponent_id(team)
    throw :team_not_present unless has_team?(team)
    id == left_team_id ? right_team_id : left_team_id
  end

  def opponent_name(team)
    throw :team_not_present unless has_team?(team)  
    id = team.class == Team ? team.id : team  
    id == left_team_id ? right_team_name : left_team_name
  end

  def opponent(team)
    throw :team_not_present unless has_team?(team) 
    id = team.class == Team ? team.id : team   
    id == left_team_id ? right_team : left_team
  end

  scope :without_final_result, :where => { :state.ne => 'final' }

  before_save :update_team_info
  def update_team_info
    self.team_ids = []
    self.division_ids ||= []
    if team = self.left_team
      self.left_team_name = team.name unless left_custom_name
      team_ids << team.id
      division_ids << team.division_id unless division_ids.include?(team.division_id)
    else
      self.left_team_name = '' unless left_custom_name
    end
    if team = self.right_team
      self.right_team_name = team.name unless right_custom_name
      team_ids << team.id
      division_ids << team.division_id unless division_ids.include?(team.division_id)
    else
      self.right_team_name = '' unless right_custom_name
    end
  end

  before_save :update_summary
  def update_summary
    puts 'updating game summary'
    unless state == 'pending'
      tag = ''
      if state == 'final'
        case completed_in
          when 'overtime' 
            tag = ' (OT)'
          when 'shootout' 
            tag = ' (SO)'
          when 'forfeit' 
            tag = ' (FORFEIT)'
        end
      end
      if left_team_score > right_team_score
        summary = "#{left_team_name} #{left_team_score}, #{right_team_name} #{right_team_score}#{tag}"
      else
        summary = "#{right_team_name} #{right_team_score}, #{left_team_name} #{left_team_score}#{tag}"
      end
    else
      summary = "#{left_team_name} vs. #{right_team_name}"
    end
    self.summary = summary
  end

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
