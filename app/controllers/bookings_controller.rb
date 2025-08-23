class BookingsController < ApplicationController
  before_action :set_owner, only: [ :schedule, :new, :create, :confirmation ]
  before_action :authenticate_user!, only: [ :index, :index ]
  before_action :set_booking, only: [:show, :mark_as_read]

  def index
    @bookings = current_user.owned_bookings.order(start_time: :asc)
  end

  def show
  end

  def mark_as_read
    @booking.update(read_by_owner: true) unless @booking.read_by_owner?
    @bookings = current_user.owned_bookings.order(start_time: :asc)
    render_notification_badge
  end

  def schedule
    @base_date = params[:base_date] ? Date.parse(params[:base_date]) : Date.current
    @dates = (@base_date..@base_date + 6.days).to_a
    @active_times = @owner.active_times.where(timerex_enabled: true).order(:day_of_week)
    range_start = @dates.first.beginning_of_day
    range_end = @dates.last.end_of_day
    @events = @owner.events.where(start_time: range_start..range_end)
    @bookings = @owner.owned_bookings.where(start_time: range_start..range_end)
    @current_step = 1

    render_turbo_partial("bookings/schedule", active_times: @active_times, owner: @owner)
  end

  def new
    @booking = @owner.owned_bookings.new
    @current_step = 2
    @booking.start_time = Time.zone.parse(params[:start_time]) if params[:start_time].present?
    @booking.end_time   = Time.zone.parse(params[:end_time]) if params[:end_time].present?

    render_turbo_partial("bookings/form", booking: @booking, owner: @owner)
  end

  def create
    @booking = @owner.owned_bookings.new(booking_params)
    if @booking.save
      create_zoom_meeting(@booking) if @owner.zoom_connected?
      BookingMailer.with(booking: @booking).confirmation_email.deliver_now
      BookingMailer.with(booking: @booking).new_booking_notification.deliver_now
      @current_step = 3
      render_turbo_replace("booking_frame", "bookings/confirmation", booking: @booking, owner: @owner, current_step: @current_step )
    else
      render_turbo_replace("booking_frame", "bookings/form", booking: @booking, owner: @owner)
    end
  end

  def confirmation
  end

  private

  def set_owner
    if params[:token].present?
      @owner = User.find_by!(booking_token: params[:token])
    else
      owner_id = params[:owner_id] || params.dig(:booking, :owner_id)
      @owner = User.find(owner_id)
    end
  end

  def booking_params
    params.require(:booking).permit(:name, :email, :start_time, :end_time, :memo)
  end

  def set_booking
    @booking = current_user.owned_bookings.find(params[:id])
  end

  def render_turbo_partial(partial, **locals)
    respond_to do |format|
      format.html
      format.turbo_stream { render partial: partial, locals: locals }
    end
  end

  def create_zoom_meeting(booking)
    zoom_service = ZoomService.new(@owner)
    meeting_data = zoom_service.create_meeting(
      topic: "予約: #{booking.name}",
      start_time: booking.start_time,
      duration: ((booking.end_time - booking.start_time) / 60).to_i
    )
    booking.update(
      zoom_join_url: meeting_data["join_url"],
      zoom_start_url: meeting_data["start_url"]
    )
  end

  def render_notification_badge
    render turbo_stream: [
        turbo_stream.replace("event_panel", template: "bookings/index", locals: { bookings: @bookings }),
        turbo_stream.replace("notification_badge", partial: "bookings/notification_count", locals:  { unread_count: current_user.unread_bookings.count })
    ]
  end

  def render_turbo_replace(target, partial, locals = {})
    render turbo_stream: turbo_stream.replace(target, partial: partial, locals: locals)
  end
end
