class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only:  %i[show edit update destroy]


  def index
    @events = current_user.events.order(:start_time)
  end

  def new
    @event = current_user.events.new
    @event.date = params[:date] if params[:date].present?
  end

  def create
    @event = current_user.events.build(event_params)

    @event.start_time = Time.zone.parse("#{event_params[:date]} #{event_params[:start_time]}")
    @event.end_time = Time.zone.parse("#{event_params[:date]} #{event_params[:end_time]}")

    if @event.save
      @event = current_user.events.new
      render_schedule_with_flash(event_panel_template: "events/new", event: @event, notice: "新規予定を追加しました")
    else
      flash.now[:alert] = "予定の追加に失敗しました"
      render turbo_stream: [
        turbo_stream.replace("event_panel", partial: "events/form", locals: { event: @event }),
        turbo_stream.replace("flash", partial: "layouts/flash")
       ], status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    @event.start_time = Time.zone.parse("#{event_params[:date]} #{event_params[:start_time]}")
    @event.end_time = Time.zone.parse("#{event_params[:date]} #{event_params[:end_time]}")

    if @event.update(event_params)
      @events = current_user.events.order(:start_time)
      render_schedule_with_flash(event_panel_template: "events/index", notice: "予定を更新しました")
    else
      flash.now[:alert] = "予定の更新に失敗しました"
      render turbo_stream: [
        turbo_stream.replace("event_panel", partial: "events/form", locals: { event: @event }),
        turbo_stream.replace("flash", partial: "layouts/flash")
      ], status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    @events = current_user.events.order(:start_time)
    render_schedule_with_flash(event_panel_template: "events/index", notice: "予定を削除しました")
  end

  private

  def set_event
    @event = current_user.events.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :note, :date, :start_time, :end_time, :category, :location)
  end

  def render_schedule_with_flash(event_panel_template:, event: nil, notice: nil)
    flash.now[:notice] = notice if notice.present?

    schedule = schedule_data(Date.current)
    event_panel_locals = { event: event }.compact

    render turbo_stream: [
      turbo_stream.replace("calendar", partial: "home/calendar", locals: { events: current_user.events }),
      turbo_stream.replace("event_panel", template: event_panel_template, locals: event_panel_locals),
      turbo_stream.replace("flash", partial: "layouts/flash"),
      turbo_stream.replace("daily_schedule", partial: "schedules/daily_schedule", locals: schedule)
    ]
  end


  def schedule_data(base_date)
    dates = (base_date - 2.days..base_date + 2.days).to_a
    grouped_events = current_user.events
      .where(start_time: dates.first.beginning_of_day..dates.last.end_of_day)
      .order(:start_time)
      .group_by { |event| event.start_time.to_date }

    date_active_times = dates.index_with do |date|
      current_user.active_times.find_by(day_of_week: date.wday)
    end
    {
      base_date: base_date,
      dates: dates,
      grouped_events: grouped_events,
      date_active_times: date_active_times
    }
  end
end
