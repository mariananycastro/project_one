class WebsocketConnectionService

  attr_reader :url, :message

  def initialize(url, message)
    @url = url
    @message = message
  end

  def self.broadcast(url, message)
    new(url, message).broadcast
  end

  def broadcast
    response = Net::HTTP.post(
      URI(url),
      message.to_json,
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{ token(message) }"
    )
  end

  private

  def token(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, ENV['JWT_SECRET'], 'HS256')
  end
end
