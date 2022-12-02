# == Schema Information
#
# Table name: recurrences
#
#  id               :bigint           not null, primary key
#  ending           :string
#  ends_on          :date
#  friday           :boolean
#  monday           :boolean
#  occurrence_count :integer
#  saturday         :boolean
#  sunday           :boolean
#  thursday         :boolean
#  tuesday          :boolean
#  wednesday        :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Recurrence < ApplicationRecord
  has_many :events, dependent: :restrict_with_exception

  validates :ending, inclusion: { in: %w[on after] }

  validates :occurrence_count, numericality: { only_integer: true, greater_than: 1, allow_blank: true }

  validates :occurrence_count, presence: true, if: -> { ending == 'after' }
  validates :ends_on, presence: true, if: -> { ending == 'on' }

  after_create :create_event_occurrences

  def create_event_occurrences
    return unless events.count == 1

    seed = events.first

    slots(seed.starts_on).each do |slot|
      seed.dup.tap do |clone|
        clone.starts_on = clone.starts_on.change(year: slot.year, month: slot.month, day: slot.day)
      end.save!
    end
  end

  private

  def slots(starts_on)
    if ending == 'after'
      schedule(starts_on).first(occurrence_count - 1)
    else
      schedule(starts_on).occurrences(Chronic.parse(ends_on).end_of_day)
    end
  end

  def schedule(starts_on)
    IceCube::Schedule.new(starts_on + 1.day) do |new_schedule|
      new_schedule.add_recurrence_rule IceCube::Rule.weekly.day(*repeat_days)
    end
  end

  def repeat_days
    Date::DAYNAMES.collect(&:downcase)
                  .select { |day| send(day) }
                  .collect(&:to_sym)
  end
end
