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
    if @event.save
      redirect_to new_event_path, notice: "新規予定を追加しました"
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
    if @event.update(event_params)
      redirect_to events_path, notice: "予定の更新を行いました"
    else
      flash[:alert] = "予定の更新に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path, notice: "予定の削除を行いました"
  end

  private

  def set_event
    @event = current_user.events.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :description, :start_time, :end_time, :color, :location)
  end
end
