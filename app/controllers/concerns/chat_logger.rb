module ChatLogger
  extend ActiveSupport::Concern

  DEBUG_CHAT_ID = -589266428

  included do
    def send_generic_log(chat, msg)
      if not msg.photo.nil? and msg.photo.length > 0
        respond_with(chat_id: DEBUG_CHAT_ID, photo: msg['photo'][0]['file_id'], caption: msg['caption'].nil? ? "" : msg['caption'])
      end

      if not msg.video.nil?
        bot.api.send_video(chat_id: DEBUG_CHAT_ID, video: msg.video.file_id, caption: msg.caption.nil? ? "" : msg.caption)
      end

      if not msg.text.nil?
        bot.api.send_message(chat_id: DEBUG_CHAT_ID, text: msg.text)
        return
      end

      if not msg.sticker.nil?
        bot.api.send_sticker(chat_id: DEBUG_CHAT_ID, sticker: msg.sticker.file_id)
        return
      end

      if not msg.animation.nil?
        bot.api.send_animation(chat_id: DEBUG_CHAT_ID, animation: msg.animation.file_id)
      end

      if not msg.voice.nil?
        bot.api.send_voice(chat_id: DEBUG_CHAT_ID, voice: msg.voice.file_id)
        return
      end

      if not msg.video_note.nil?
        bot.api.send_video_note(chat_id: DEBUG_CHAT_ID, video_note: msg.video_note.file_id)
        return
      end

      if not msg.document.nil?
        bot.api.send_document(chat_id: DEBUG_CHAT_ID, document: msg.document.file_id)
        return
      end
    end

    def send_log(bot, log_msg)
      bot.api.send_message(chat_id: DEBUG_CHAT_ID, text: log_msg)
    end
  end
end
