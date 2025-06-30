class ActiveTime < ApplicationRecord
  belongs_to :user

  validates :start_time, :end_time, presence: true
  validates :granularity_minutes, inclusion: { in: [ 15, 30, 45, 60 ] }
  validate :start_time_before_end_time

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

  def start_time_before_end_time
    return if start_time.blank? || end_time.blank?

    if start_time > end_time
      errors.add(:start_time, "は終了時間より前にしてください")
    end
  end
end
