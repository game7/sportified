# == Schema Information
#
# Table name: events
#
#  id                        :integer          not null, primary key
#  tenant_id                 :integer
#  division_id               :integer
#  season_id                 :integer
#  location_id               :integer
#  type                      :string
#  starts_on                 :datetime
#  ends_on                   :datetime
#  duration                  :integer
#  all_day                   :boolean
#  summary                   :string
#  description               :text
#  mongo_id                  :string
#  created_at                :datetime
#  updated_at                :datetime
#  home_team_id              :integer
#  away_team_id              :integer
#  statsheet_id              :integer
#  statsheet_type            :string
#  home_team_score           :integer          default(0)
#  away_team_score           :integer          default(0)
#  home_team_name            :string
#  away_team_name            :string
#  home_team_custom_name     :boolean
#  away_team_custom_name     :boolean
#  text_before               :string
#  text_after                :string
#  result                    :string
#  completion                :string
#  exclude_from_team_records :boolean
#  playing_surface_id        :integer
#  home_team_locker_room_id  :integer
#  away_team_locker_room_id  :integer
#  program_id                :integer
#  page_id                   :integer
#
# Indexes
#
#  index_events_on_away_team_id              (away_team_id)
#  index_events_on_away_team_locker_room_id  (away_team_locker_room_id)
#  index_events_on_division_id               (division_id)
#  index_events_on_home_team_id              (home_team_id)
#  index_events_on_home_team_locker_room_id  (home_team_locker_room_id)
#  index_events_on_location_id               (location_id)
#  index_events_on_mongo_id                  (mongo_id)
#  index_events_on_page_id                   (page_id)
#  index_events_on_playing_surface_id        (playing_surface_id)
#  index_events_on_program_id                (program_id)
#  index_events_on_season_id                 (season_id)
#  index_events_on_tenant_id                 (tenant_id)
#
# Foreign Keys
#
#  fk_rails_...  (page_id => pages.id)
#  fk_rails_...  (program_id => programs.id)
#

class League::Game < League::Event
  extend Enumerize

  belongs_to :home_team, class_name: '::League::Team', required: false
  belongs_to :away_team, class_name: '::League::Team', required: false
  belongs_to :statsheet, polymorphic: true, required: false

  belongs_to :playing_surface, required: false

  enumerize :result, in: [ :pending, :final ], default: :pending
  enumerize :completion, in: [ :regulation, :overtime, :shootout, :forfeit]

  validates_numericality_of :away_team_score, :only_integer => true
  def away_team_is_winner?
    return away_team_score > home_team_score if result
  end

  validates_numericality_of :home_team_score, :only_integer => true
  def home_team_is_winner?
    return away_team_score < home_team_score if result
  end

  def has_team?(team)
    id = team.class == League::Team ? team.id : team
    id == away_team_id || id == home_team_id
  end

  def opponent_id(team)
    throw :team_not_present unless has_team?(team)
    id == away_team_id ? home_team_id : away_team_id
  end

  def opponent_name(team)
    throw :team_not_present unless has_team?(team)
    id = team.class == League::Team ? team.id : team
    id == away_team_id ? home_team_name : away_team_name
  end

  def opponent(team)
    throw :team_not_present unless has_team?(team)
    id = team.class == League::Team ? team.id : team
    id == away_team_id ? home_team : away_team
  end

  def team_scored(team)
    self.home_team_id == team.id ? self.home_team_score : self.away_team_score
  end

  def team_allowed(team)
    self.home_team_id == team.id ? self.away_team_score : self.home_team_score
  end

  def team_margin(team)
    team_scored(team) - team_allowed(team)
  end

  def team_score(team)
    "#{team_scored(team)}-#{team_allowed(team)}"
  end

  def team_decision(team)
    margin = team_margin(team)
    return 'T' if margin == 0
    return 'W' if margin > 0
    return 'L' if margin < 0
  end

  before_save :update_team_info
  def update_team_info
    if team = self.away_team
      self.away_team_name = team.name unless away_team_custom_name
    else
      self.away_team_name = '' unless away_team_custom_name
    end
    if team = self.home_team
      self.home_team_name = team.name unless home_team_custom_name
    else
      self.home_team_name = '' unless home_team_custom_name
    end
  end

  before_save :update_summary
  def update_summary
    if result.final?
      tag = ''
      if completion.overtime?
        tag = ' (OT)'
      elsif completion.shootout?
        tag = ' (SO)'
      elsif completion.forfeit?
        tag = ' (FORFEIT)'
      end
      if away_team_score > home_team_score
        summary = "#{away_team_name} #{away_team_score}, #{home_team_name} #{home_team_score}#{tag}"
      else
        summary = "#{home_team_name} #{home_team_score}, #{away_team_name} #{away_team_score}#{tag}"
      end
    else
      summary = "#{away_team_name} at #{home_team_name}"
    end
    summary = [text_before, summary, text_after].join(" ").strip
    self.summary = summary
  end

  after_save :calculate_team_records
  def calculate_team_records
    home_team.calculate_record && home_team.save if home_team
    away_team.calculate_record && away_team.save if away_team
  end

  def display_score?
    self.result.final?
  end

  def has_statsheet?
    self.statsheet_id.present?
  end

  def can_add_statsheet?
    !self.has_statsheet? && self.starts_on < DateTime.now
  end

  def show_teams?
    true
  end

  scope :without_result, ->{ where(result: nil) }

  class << self
    def for_team(t)
      id = t.class ==  League::Team ? t.id : t
      where('home_team_id = ? OR away_team_id = ?', id, id)
    end

    def for_teams(team1, team2)
      for_team(team1).for_team(team2)
    end
  end

  def color_key
    "division-#{division_id}"
  end

end
