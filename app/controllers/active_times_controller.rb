class ActiveTimesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_active_time, only: [ :edit, :update ]
  before_action :ensure_owner, only: [ :edit, :update ]

  def index
    @active_times = current_user.active_times.order(:day_of_week)

    if params[:edit_id].present?
      @editing_active_time = current_user.active_times.find_by(id: params[:edit_id])
    end
  end

  def edit
  end

  def update
    if @active_time.update(active_time_params)
      redirect_to active_time_path, notice: "活動時間を更新しました"
    else
      flash.now[:alert] = "更新に失敗しました。"
      render :index
    end
  end

  def set_active_time
    @active_time = ActiveTime.find(params[:id])
  end

  def ensure_owner
    redirect_to root_path, alert: "アクセスできません" unless @active_time.user == current_user
  end

  def active_time_params
    params.require(:active_time).permit(:day_of_week, :start_time, :end_time, :granularity_minutes)
  end
end
