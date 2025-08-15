class BookingsController < ApplicationController
  before_action :set_owner, only: [ :schedule, :new, :create, :confirmation ]
  before_action :authenticate_user!, only: [ :index ]

  def index
    @bookings = current_user.owned_bookings.order(start_time: :asc)
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
    respond_to do |format|
      format.html
      format.turbo_stream do
        render partial: "bookings/schedule", locals: { active_times: @active_times, owner: @owner }
      end
    end
  end

  def new
    @booking = @owner.owned_bookings.new
    @current_step = 2
    if params[:start_time].present?
      @booking.start_time = Time.zone.parse(params[:start_time])
    end
    if params[:end_time].present?
      @booking.end_time = Time.zone.parse(params[:end_time])
    end

    respond_to do |format|
      format.html
      format.turbo_stream do
        render partial: "bookings/form", locals: { booking: @booking, owner: @owner }
      end
    end
  end

  def create
    @booking = @owner.owned_bookings.new(booking_params)
    if @booking.save
      BookingMailer.with(booking: @booking).confirmation_email.deliver_later

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "booking_frame",
            partial: "bookings/confirmation",
            locals: { booking: @booking }
          )
        end
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "booking_frame",
            partial: "bookings/form",
            locals: { booking: @booking, owner: @owner }
          )
        end
      end
    end
  end

  def confirmation
    @booking = @owner.owned_bookings.find(params[:id])
    @current_step = 3
  end

  private

  def set_owner
    owner_id = params[:owner_id] || params.dig(:booking, :owner_id)
    @owner = User.find(owner_id)
  end

  def booking_params
    params.require(:booking).permit(:name, :email, :start_time, :end_time, :memo)
  end
end
