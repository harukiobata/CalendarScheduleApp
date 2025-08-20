class ZoomController < ApplicationController
  before_action :authenticate_user!

  def auth
    client_id    = Rails.application.config.x.zoom.client_id
    redirect_uri = Rails.application.config.x.zoom.redirect_url

    zoom_auth_url = "https://zoom.us/oauth/authorize?" +
                    "response_type=code&" +
                    "client_id=#{client_id}&" +
                    "redirect_uri=#{redirect_uri}"

    redirect_to zoom_auth_url, allow_other_host: true
  end

  def callback
    if params[:code].present?
      ZoomService.new(current_user).exchange_token(params[:code])
      redirect_to root_path, notice: "Zoom連携が完了しました"
    else
      redirect_to root_path, alert: "Zoom連携に失敗しました"
    end
  end
end
