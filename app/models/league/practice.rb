# == Schema Information
#
# Table name: events
#
#  id                        :integer          not null, primary key
#  all_day                   :boolean
#  away_team_custom_name     :boolean
#  away_team_name            :string
#  away_team_score           :integer          default(0)
#  completion                :string
#  description               :text
#  duration                  :integer
#  ends_on                   :datetime
#  exclude_from_team_records :boolean
#  home_team_custom_name     :boolean
#  home_team_name            :string
#  home_team_score           :integer          default(0)
#  private                   :boolean          default(FALSE), not null
#  result                    :string
#  starts_on                 :datetime
#  statsheet_type            :string
#  summary                   :string
#  text_after                :string
#  text_before               :string
#  type                      :string
#  created_at                :datetime
#  updated_at                :datetime
#  away_team_id              :integer
#  away_team_locker_room_id  :integer
#  division_id               :integer
#  home_team_id              :integer
#  home_team_locker_room_id  :integer
#  location_id               :integer
#  page_id                   :integer
#  playing_surface_id        :integer
#  program_id                :integer
#  season_id                 :integer
#  statsheet_id              :integer
#  tenant_id                 :integer
#
# Indexes
#
#  index_events_on_away_team_id              (away_team_id)
#  index_events_on_away_team_locker_room_id  (away_team_locker_room_id)
#  index_events_on_division_id               (division_id)
#  index_events_on_home_team_id              (home_team_id)
#  index_events_on_home_team_locker_room_id  (home_team_locker_room_id)
#  index_events_on_location_id               (location_id)
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
class League::Practice < League::Event
    extend Enumerize

    default_scope { where(type: klass.name) }

    belongs_to :home_team, class_name: '::League::Team', required: false
    belongs_to :away_team, class_name: '::League::Team', required: false
  
    belongs_to :playing_surface, required: false
    
    validates_presence_of :program_id
    
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
  
    before_validation :update_team_info
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
  
    before_validation :update_summary
    def update_summary
      self.summary = [text_before, away_team_name, '/', home_team_name, text_after].join(" ").strip
    end
   
    def show_teams?
      true
    end

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
