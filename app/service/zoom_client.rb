class ZoomClient
  require "net/http"
  require "uri"
  require "json"

  def initialize
    @client_id = Rails.application.config.x.zoom.client_id
    @client_secret = Rails.application.config.x.zoom.client_secret
    @redirect_uri = Rails.application.config.x.zoom.redirect_url
  end

  def get_token(code)
    uri = URI("https://zoom.us/oauth/token?grant_type=authorization_code&code=#{code}&redirect_uri=#{@redirect_uri}")
    req = Net::HTTP::Post.new(uri)
    req.basic_auth(@client_id, @client_secret)
    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
    JSON.parse(res.body)
  end
end
