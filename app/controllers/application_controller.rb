class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :username ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :username ])
  end

  def set_schedule_data
    @base_date = params[:date]&.to_date || Date.current
    @dates = (@base_date - 2.days..@base_date + 2.days).to_a
    @grouped_events = current_user.events
      .where(start_time: @dates.first.beginning_of_day..@dates.last.end_of_day)
      .order(:start_time)
      .group_by { |event| event.start_time.to_date }
    @active_times = current_user.active_times.index_by(&:day_of_week)
    @date_active_times = @dates.index_with { |date| @active_times[date.wday] }
  end
end
