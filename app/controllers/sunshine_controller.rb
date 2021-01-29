class SunshineController < Telegram::Bot::UpdatesController
  include TranslateProvider
  include Telegram::Bot::UpdatesController::TypedUpdate

  before_action :set_chat_id, :set_current_user

  def start!(*args)
    @chat.update!(enabled: true)
      respond_with :message, text: 'Enabled'
  end

  def message(message)
    return unless @user.username.eql?('zah_ai')
    bot.delete_message(chat_id: chat['id'], message_id: message['message_id'])

    if !message.text.nil? && message['text'].include?('http') || !message['video'].nil?
      respond_with(chat_id: chat['id'], text: get_url('ambient_urls'))
    end

    if !message['photo'].nil? && message['photo'].length > 0
      respond_with(chat_id: chat['id'], text: get_url('photo_urls'))
    end

    if !message['voice'].nil? || !message['video_note'].nil?
      respond_with(chat_id: chat['id'], text: get_url('audio_urls'))
    end

    unless message['sticker'].nil?
      respond_with(chat_id: chat['id'], sticker: get_url('sticker_ids'))
    end

    bot.api.send_message(chat_id: chat['id'], text: translated_text.capitalize)
  end

  def stop!(*args)
      @chat.update!(enabled: false)
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
end

