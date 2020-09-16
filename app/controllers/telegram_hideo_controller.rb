
class TelegramHideoController < Telegram::Bot::UpdatesController
  before_action :init

  def tweet!
    tweets = @client.user_timeline(117652722, count: 15)
    tw = Tweet.last&.tweet_id
    tw ||= 0
    tweets.map do |i|
      if i.id > tw
        respond_with :message, text: i['text']
        Tweet.create!(tweet_id: tweet['id'])
      end
    end
    respond_with :message, text: '何も新しい先輩'
  end

  private

  def init
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = Rails.application.credentials[:twitter][:consumer_key]
      config.consumer_secret     = Rails.application.credentials[:twitter][:consumer_secret]
      config.access_token        = Rails.application.credentials[:twitter][:access_token]
      config.access_token_secret = Rails.application.credentials[:twitter][:access_token_secret]
    end
  end
end