class TwitterService

  attr_reader :client

  def initialize
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key         = Rails.application.credentials.twitter[:consumer_key]
      config.consumer_secret      = Rails.application.credentials.twitter[:consumer_secret]
      config.access_token         = Rails.application.credentials.twitter[:access_token]
      config.access_token_secret  = Rails.application.credentials.twitter[:access_token_secret]
    end
  end

  def from(handle, take = 5)
    client.search("from:#{handle}", result_type: :recent).take(take)
  end

end
