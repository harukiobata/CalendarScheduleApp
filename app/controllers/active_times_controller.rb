class ActiveTimesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_active_time, only: [ :update ]
  before_action :set_active_times, only: [ :index, :update ]

  def index
    if params[:edit_id].present?
      @editing_active_time = current_user.active_times.find_by(id: params[:edit_id])
    end
  end

  def update
    if @active_time.update(active_time_params)
      redirect_to active_time_path, notice: "活動時間を更新しました"
    else
      @editing_active_time = @active_time
      flash.now[:alert] = "更新に失敗しました"
      render :index, status: :unprocessable_entity
    end
  end

  def update_granularity
    new_granularity = params[:granularity_minutes].to_i
    current_user.active_times.update_all(granularity_minutes: new_granularity)
    redirect_to active_times_path, notice: "スケジュールの表示間隔（#{new_granularity}分）を全曜日に適用しました"
  end

  private

  def set_active_time
    @active_time = ActiveTime.find(params[:id])
  end

  def set_active_times
    @active_times = current_user.active_times.order(:day_of_week)
  end

  def active_time_params
    params.require(:active_time).permit(:day_of_week, :start_time, :end_time, :granularity_minutes)
  end
end
