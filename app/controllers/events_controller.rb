class EventsController < ApplicationController
  before_action :authenticate_user!, only: %i[create update destroy]
  before_action :set_event, only:  %i[show edit update destroy]


  def index
    @events = current_user ? current_user.events.order(:start_time) : Event.none
  end

  def new
    if current_user
      @event = current_user.events.new
      @event.date = params[:date] if params[:date].present?

      if params[:start_time].present? && params[:end_time].present?
        @event.start_time = Time.zone.parse("#{params[:date]} #{params[:start_time]}")
        @event.end_time   = Time.zone.parse("#{params[:date]} #{params[:end_time]}")
      end
    else
      @event = Event.new
    end
  end

  def create
    @event = current_user.events.build(event_params)
    parse_and_set_times(@event, event_params)
    if @event.save
      @event = current_user.events.new
      render_schedule_with_flash(event_panel_template: "events/new", event: @event, notice: "新規予定を追加しました")
    else
      render_form_with_alert("events/new", "予定の追加に失敗しました")
    end
  end

  def show
  end

  def edit
  end

  def update
    parse_and_set_times(@event, event_params)
    if @event.update(event_params.except(:start_time, :end_time))
      @events = current_user.events.order(:start_time)
      render_schedule_with_flash(event_panel_template: "events/index", notice: "予定を更新しました")
    else
      render_form_with_alert("events/edit", "予定の更新に失敗しました")
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

  def parse_and_set_times(event, params)
    event.start_time = Time.zone.parse("#{params[:date]} #{params[:start_time]}")
    event.end_time = Time.zone.parse("#{params[:date]} #{params[:end_time]}")
  end

  def render_schedule_with_flash(event_panel_template:, event: nil, notice: nil)
    flash.now[:notice] = notice if notice.present?

    set_schedule_data
    event_panel_locals = { event: event }.compact

    render turbo_stream: [
      turbo_stream.replace("calendar", partial: "home/calendar", locals: { events: current_user.events }),
      turbo_stream.replace("event_panel", template: event_panel_template, locals: event_panel_locals),
      turbo_stream.replace("flash", partial: "shared/flash"),
      turbo_stream.replace("daily_schedule", template: "schedules/daily_schedule", locals: { base_date: @base_date,
      dates: @dates,
      grouped_events: @grouped_events,
      date_active_times: @date_active_times})
    ]
  end

  def render_form_with_alert(template, alert_message)
    flash.now[:alert] = alert_message
    render turbo_stream: [
      turbo_stream.replace("event_panel", template: template, locals: { event: @event }),
      turbo_stream.replace("flash", partial: "shared/flash")
    ], status: :unprocessable_entity
  end
end
