
class TelegramHideoController < Telegram::Bot::UpdatesController
  before_action :init

  def twit!
    twits = @client.user_timeline(117652722, count: 15)
    l  = -> twit { Tweet.find_by(tweet_id: twit.id).nil? }
    new_twit = -> twit { respond_with :message, text: twit['text']; Tweet.create!(tweet_id: twit['id'])}
    new_twits = twits.select &l
    new_twits.map{|i| new_twit.call(i)}
    respond_with :message, text: 'иди своей дорогой, сталкер'
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