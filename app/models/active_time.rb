class ActiveTime < ApplicationRecord
  belongs_to :user

  validates :start_time, :end_time, presence: true
  validates :granularity_minutes, inclusion: { in: [ 15, 30, 45, 60 ] }
  validate :end_time_before_start_time
  validate :activetime_time_cannot_be_change_after_event

  # ex: 13:30 => 810
  def minutes_since_midnight(time)
    time.hour * 60 + time.min
  end

  def time_blocks
    blocks = []
    current_time = Time.zone.parse("00:00")
    end_time_of_day = Time.zone.parse("23:59")
    while current_time < end_time_of_day
      block_end = [ current_time + granularity_minutes.minutes, end_time_of_day ].min
      blocks << [ current_time, block_end ]
      current_time = block_end
    end
    blocks
  end

  def within_time_range?(block_start_time, block_end_time)
    block_start = minutes_since_midnight(block_start_time)
    block_end = minutes_since_midnight(block_end_time)
    active_start = minutes_since_midnight(start_time)
    active_end = minutes_since_midnight(end_time)

    block_start >= active_start && block_end <= active_end
  end

  private

  def end_time_before_start_time
    return if start_time.blank? || end_time.blank?

    if end_time <= start_time
      errors.add(:end_time, "は開始時間より後にしてください")
    end
  end

  def activetime_time_cannot_be_change_after_event
    events_on_same_day = Event.where(user_id: user_id)
                            .where("EXTRACT(DOW FROM date) = ?", day_of_week)

    unless events_on_same_day.all? do |e|
      active_start = start_time.strftime("%H:%M:%S")
      active_end   = end_time.strftime("%H:%M:%S")
      event_start  = e.start_time.strftime("%H:%M:%S")
      event_end    = e.end_time.strftime("%H:%M:%S")
      active_start <= event_start && active_end >= event_end
    end
      errors.add(:start_time, "又は終了時間は既存のイベントの時間を含むように設定してください")
    end
  end
end
