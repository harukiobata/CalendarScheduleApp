class ZoomService
  BASE_URL = "https://api.zoom.us/v2"

  def initialize(user)
    @user = user
    @token = user.zoom_access_token
  end

  def exchange_token(code)
    client = ZoomClient.new
    token_data = client.get_token(code)

    @user.update!(
      zoom_access_token: token_data["access_token"],
      zoom_refresh_token: token_data["refresh_token"],
      zoom_token_expires_at: Time.current + token_data["expires_in"].to_i.seconds
    )
  end

  def create_meeting(topic:, start_time:, duration:)
    response = Faraday.post("#{BASE_URL}/users/me/meetings") do |req|
      req.headers["Authorization"] = "Bearer #{@token}"
      req.headers["Content-Type"] = "application/json"
      req.body = {
        topic: topic,
        type: 2,
        start_time: start_time.iso8601,
        duration: duration,
        timezone: "Asia/Tokyo"
      }.to_json
    end
    JSON.parse(response.body)
  end
end
