module BookingsHelper
  def schedule_display_range(active_times)
    ranges = active_times.map do |at|
      start_min = at.display_start_time.hour * 60 + at.display_start_time.min
      end_min = at.display_end_time.hour * 60 + at.display_end_time.min
      [ start_min, end_min ]
    end

    start_min = ranges.map(&:first).min
    end_min = ranges.map(&:last).max

    start_time = Time.zone.parse(format("%02d:%02d", start_min / 60, start_min % 60))
    end_time = Time.zone.parse(format("%02d:%02d", end_min / 60, end_min % 60))
    [ start_time, end_time ]
  end

  def build_time_slots(active_time)
    return [] unless active_time

    start_time = active_time.display_start_time || active_time.start_time
    end_time   = active_time.display_end_time   || active_time.end_time

    if start_time > end_time
      start_time = start_time.beginning_of_day
      end_time   = start_time.end_of_day
    end

    slots = []
    step       = active_time.granularity_minutes.minutes

    current_start = start_time
    while current_start < end_time
      current_end = [ current_start + step, end_time ].min
      slots << [ current_start, current_end ]
      current_start = current_end
    end

    slots
  end

  def booking_or_event_exists?(bookings, events, date, slot_start, slot_end)
    slot_start_full = Time.zone.local(date.year, date.month, date.day, slot_start.hour, slot_start.min)
    slot_end_full   = Time.zone.local(date.year, date.month, date.day, slot_end.hour, slot_end.min)

    overlaps = ->(record) { (record.start_time < slot_end_full) && (record.end_time > slot_start_full) }
    bookings.any?(&overlaps) || events.any?(&overlaps)
  end
end
