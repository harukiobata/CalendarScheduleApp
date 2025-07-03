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
    overlapping_events = Event.where("EXTRACT(DOW FROM start_time) = ?", day_of_week).where(
    "start_time < :start OR end_time > :end",
    start: start_time,
    end: end_time
    )

    if overlapping_events.exists?
      errors.add(:start_time, "又は終了時間は既存のイベントの時間を含むように設定してください")
    end
  end
end
