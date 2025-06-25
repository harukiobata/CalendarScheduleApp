class SchedulesController < ApplicationController
  before_action :set_schedule_data

  def index
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
