module BookingsHelper
  def schedule_display_range(active_times)
    ranges = active_times.map do |at|
      start_min = at.display_start_time.hour * 60 + at.display_start_time.min
      end_min = at.display_end_time.hour * 60 + at.display_end_time.min
      [start_min, end_min]
    end

    start_min = ranges.map(&:first).min
    end_min = ranges.map(&:last).max

    start_time = Time.zone.parse(format("%02d:%02d", start_min / 60, start_min % 60))
    end_time = Time.zone.parse(format("%02d:%02d", end_min / 60, end_min % 60))
    [start_time, end_time]
  end

  def build_time_slots(active_time)
    return [] unless active_time

    slots = []
    start_time = active_time.start_time
    end_time   = active_time.end_time
    step       = active_time.granularity_minutes.minutes

    current_start = start_time
    while current_start < end_time
      current_end = [current_start + step, end_time].min
      slots << [current_start, current_end]
      current_start = current_end
    end

    slots
  end

  def booking_exists?(bookings, date, slot_start, slot_end)
    bookings.any? do |booking|
      booking_start = booking.start_time
      booking_end = booking.end_time

      booking_start.to_date == date &&
        booking_start < slot_end &&
        booking_end > slot_start
    end
  end
end
