module ChatLogger
  extend ActiveSupport::Concern

  DEBUG_CHAT_ID = -589266428

  included do
    def send_generic_log(bot, msg)
      unless msg['photo'].blank?
        bot.send_photo(chat_id: DEBUG_CHAT_ID, photo: msg['photo'][0]['file_id'], caption: msg['caption'].nil? ? "" : msg['caption'])
      end

      unless msg['video'].nil?
        bot.send_video(chat_id: DEBUG_CHAT_ID, video: msg['video']['file_id'], caption: msg['caption'].nil? ? "" : msg['caption'])
      end

      unless msg['text'].nil?
        bot.send_message(chat_id: DEBUG_CHAT_ID, text: msg['text'])
        return
      end

      unless msg['sticker'].nil?
        bot.send_sticker(chat_id: DEBUG_CHAT_ID, sticker: msg['sticker']['file_id'])
        return
      end

      unless msg['animation'].nil?
        bot.send_animation(chat_id: DEBUG_CHAT_ID, animation: msg['animation']['file_id'])
      end

      unless msg['voice'].nil?
        bot.send_voice(chat_id: DEBUG_CHAT_ID, voice: msg['voice']['file_id'])
        return
      end

      unless msg['video_note'].nil?
        bot.api.send_video_note(chat_id: DEBUG_CHAT_ID, video_note: msg['video_note']['file_id'])
        return
      end

      unless msg['document'].nil?
        bot.api.send_document(chat_id: DEBUG_CHAT_ID, document: msg['document']['file_id'])
        return
      end
    end
  end
end
