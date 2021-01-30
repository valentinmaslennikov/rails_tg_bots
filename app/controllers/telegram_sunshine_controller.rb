class TelegramSunshineController < Telegram::Bot::UpdatesController
  include TranslateProvider
  include Telegram::Bot::UpdatesController::TypedUpdate
  include ChatLogger

  before_action :set_chat_id, :set_current_user, :create_chat_bot_record
  before_action :check_enabled, except: [:start!]

  BOT_NAME = 'sunshine'

  def start!(*args)
    @chat_bot.update!(enabled: true)
    respond_with :message, text: 'Enabled'
  end

  def message(message)
    #return unless @user.username.eql?('loyalistscfa')
    bot.delete_message(chat_id: chat['id'], message_id: message['message_id'])
    #send_generic_log(chat, message)
    
    if !message.text.nil? && message['text'].include?('http') || !message['video'].nil?
      puts '//////////1'
      respond_with(chat_id: chat['id'], text: get_url('ambient_urls'))
    end

    unless message['photo'].blank?
      puts '//////////2'
      respond_with(chat_id: chat['id'], text: get_url('photo_urls'))
    end

    if !message['voice'].nil? || !message['video_note'].nil?
      puts '//////////3'
      respond_with(chat_id: chat['id'], text: get_url('audio_urls'))
    end

    unless message['sticker'].nil?
      puts '//////////4'
      respond_with(chat_id: chat['id'], sticker: get_url('sticker_ids'))
    end
    puts '//////////5'
    respond_with(chat_id: chat['id'], text: translated_text.capitalize)
  rescue Exception => e
    puts e
  end

  def stop!(*args)
    @chat_bot.update!(enabled: false)
    respond_with :message, text: 'Disabled'
  end

  private

  def set_current_user
    @user = User.find_or_create_by(telegram_id: from['id']) do |user|
      user.first_name = from['first_name']
      user.last_name = from['last_name']
      user.username = from['username']
      user.chat = @chat
    end
  end

  def set_chat_id
    @chat = Chat.find_or_create_by(system_id: chat['id'])
  end

  def create_chat_bot_record
    @chat_bot = @chat.bots.find_or_create_by!(name: BOT_NAME) do |t|
      t.enabled = true
    end
  end

  def check_enabled
    throw(:abort) unless @chat_bot.enabled?
  end
end
