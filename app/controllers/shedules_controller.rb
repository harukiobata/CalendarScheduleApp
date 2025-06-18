class ShedulesController < ApplicationController
  before_action :authenticate_user!

  def index
    @base_date = params[:date]&.to_date || Date.current
    @dates = (@base_date - 2.days..@base_date + 2.days).to_a
    @grouped_events = current_user.events
      .where(start_time: @dates.first.beginning_of_day..@dates.last.end_of_day)
      .order(:start_time)
      .group_by { |event| event.start_time.to_date }
    @active_times = current_user.active_times.index_by(&:weekday)
    @date_active_times = @dates.index_with { |date| @active_times[date.wday] }
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "daily_schedule",
          partial: "schedules/daily_schedule",
          locals: {
            base_date: @base_date,
            dates: @dates,
            grouped_events: @grouped_events,
            date_active_times: @date_active_times
          }
        )
      end
    end
  end
end
