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
      flash.now[:notice] = "新規予定を追加しました"
      @event = current_user.events.new
      render turbo_stream: [
      turbo_stream.replace("calendar", partial: "home/calendar", locals: { events: current_user.events }),
      turbo_stream.replace("event_panel", template: "events/new", locals: { event: @event }),
      turbo_stream.replace("flash", partial: "layouts/flash")
    ]   
      #redirect_to new_event_path, notice: "新規予定を追加しました"
    else
      flash[:alert] = "予定の追加に失敗しました"
      render :new, status: :unprocessable_entity
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
      flash.now[:notice] = "予定を更新しました"
      @events = current_user.events.order(:start_time)
      render turbo_stream: [
        turbo_stream.replace("calendar", partial: "home/calendar", locals: { events: current_user.events }),
        turbo_stream.replace("event_panel", template: "events/index"),
        turbo_stream.replace("flash", partial: "layouts/flash")
      ]
      #redirect_to events_path, notice: "予定の更新を行いました"
    else
      flash[:alert] = "予定の更新に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    flash.now[:notice] = "予定を削除しました"
    @events = current_user.events.order(:start_time)
    render turbo_stream: [
      turbo_stream.replace("calendar", partial: "home/calendar", locals: { events: current_user.events }),
      turbo_stream.replace("event_panel", template: "events/index"),
      turbo_stream.replace("flash", partial: "layouts/flash")
    ]
    #redirect_to events_path, notice: "予定の削除を行いました"
  end

  private

  def set_event
    @event = current_user.events.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :note, :date, :start_time, :end_time, :category, :location)
  end
end
