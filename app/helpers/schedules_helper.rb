module SchedulesHelper
  CATEGORY_COLORS = {
    "重要" => "#e74c3c",
    "仕事" => "#3498db",
    "プライベート" => "#2ecc71",
    "その他" => "#95a5a6"
  }

  def category_color(category_name)
    CATEGORY_COLORS[category_name]
  end

  def minutes_since_midnight(time)
    time.hour * 60 + time.min
  end

  def time_blocks_for(granularity_minutes)
    blocks = []
    start_time = Time.zone.parse("00:00")
    end_time = Time.zone.parse("23:59")
    while start_time < end_time
      block_end = start_time + granularity_minutes.minutes
      blocks << [ start_time, block_end ]
      start_time = block_end
    end
    blocks
  end

  def within_active_time?(start_time, end_time, active_time)
    block_start = start_time.strftime("%H:%M")
    block_end = end_time.strftime("%H:%M")
    active_start = active_time.start_time.strftime("%H:%M")
    active_end = active_time.end_time.strftime("%H:%M")
    block_start >= active_start && block_end <= active_end
  end
end
