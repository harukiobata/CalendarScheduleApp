class Event < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :date, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validate  :end_before_start, if: -> { start_time.present? && end_time.present? }
  validate  :no_time_overlap, if: -> { start_time.present? && end_time.present? }
  validate  :within_active_time, if: -> { start_time.present? && end_time.present? }

  private

  def end_before_start
    if end_time <= start_time
      errors.add(:end_time, "は開始時間より後である必要があります")
    end
  end

  def no_time_overlap
    overlapping_events = Event.where(user_id: user_id).where.not(id: id).where("start_time < ? AND end_time > ?", end_time, start_time)

    if overlapping_events.exists?
      conflict_titles = overlapping_events.pluck(:title).join(", ")
      errors.add(:title, "が重なっています: #{conflict_titles}")
    end
  end

  def within_active_time
    event_day = start_time.wday
    active_times_for_day = user.active_times.where(day_of_week: event_day)
    event_start = start_time.strftime("%H:%M:%S")
    event_end = end_time.strftime("%H:%M:%S")
    valid = active_times_for_day.any? do |at|
      at_start = at.start_time.strftime("%H:%M:%S")
      at_end = at.end_time.strftime("%H:%M:%S")
      (event_start >= at_start) && (event_end <= at_end)
    end

    unless valid
      errors.add(:start_time, "は活動時間内でなければなりません")
    end
  end
end
