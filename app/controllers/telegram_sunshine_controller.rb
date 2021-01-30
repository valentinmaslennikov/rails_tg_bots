class TelegramSunshineController < Telegram::Bot::UpdatesController
  include TranslateProvider
  include Telegram::Bot::UpdatesController::TypedUpdate
  include ChatLogger

  before_action :set_chat_id, :set_current_user, :create_chat_bot_record
  before_action :check_enabled, except: [:start!]

  BOT_NAME = 'sunshine'
  VOCAB = {
    "adjectives":   [
                      "лучезарное",
                      "веселое",
                      "сияющее",
                      "утреннее",
                      "заливное",
                      "поющее"
                    ],
    "objects":      [
                      "солнышко",
                      "облачко",
                      "деревце",
                      "ключишко",
                      "личико",
                      "настроение"
                    ],
    "verbs":        [
                      "посылает",
                      "испускает",
                      "сочит",
                      "струит",
                      "источает"
                    ],
    "subjects":     [
                      "цветочки",
                      "лучики добра",
                      "мелочишко",
                      "водичку",
                      "счастье",
                      "радость"
                    ],
    "destinations": [
                      "волчишкам и зверушкам",
                      "зайчишкам и крольчишкам",
                      "птичкам и жучкам",
                      "пчёлкам и цвяточкам",
                      "гномикам и хоббитам",
                      "заботливым мишкам"
                    ],
    "ambient_urls": [
                      "https://www.youtube.com/watch?v=L6JG_L-PWMA",
                      "https://www.youtube.com/watch?v=zofBinqC2F4",
                      "https://www.youtube.com/watch?v=ipf7ifVSeDU",
                      "https://www.youtube.com/watch?v=UZ9uyQI3pF0",
                      "https://www.youtube.com/watch?v=FD9X71Y3XxA",

                      "https://www.youtube.com/watch?v=VJOwaiTy1lE",
                      "https://www.youtube.com/watch?v=vz91QpgUjFc",
                      "https://www.youtube.com/watch?v=IvJQTWGP5Fg",
                      "https://www.youtube.com/watch?v=tRv2q-kHIo0",
                      "https://www.youtube.com/watch?v=lA1ItxM9yIE",
                      "https://www.youtube.com/watch?v=WjOJis4UR44",
                      "https://www.youtube.com/watch?v=3sL0omwElxw",
                      "https://www.youtube.com/watch?v=Kl2v9ydanrI",
                      "https://www.youtube.com/watch?v=AktCxFQNU7c"
                    ],
    "photo_urls":   [
                      "https://media.istockphoto.com/photos/sunny-meadow-and-blue-skies-picture-id1003623396?k=6&m=1003623396&s=170667a&w=0&h=FurVwHNDSX7l5aaVJ5bCUBR62PyIqLGQq-1yoCTM2gk=",
                      "https://thumbs.dreamstime.com/b/sunny-meadow-20896262.jpg",
                      "https://i.imgur.com/Pp4ITaw.jpg",
                      "https://media.istockphoto.com/photos/wild-horses-on-a-sunny-meadow-in-the-mountains-of-kyrgyzstan-picture-id867222128?k=6&m=867222128&s=170667a&w=0&h=Yjp0TTg9qpSXWr6pHSTIuDOjM_3J_Apy0XMW-llHYPc=",
                      "https://i.pinimg.com/originals/86/c8/37/86c837c764664315584ee0f1e444e22e.jpg",
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS4mUk1P0BMuDzJ80iGyxSQpo8d3Z6vZdLgYg&usqp=CAU",
                      "https://lh3.googleusercontent.com/proxy/NKBgNqZVeIX4csHMJQg2ZqehPVuJd36FgHVc9q0BpS4VV7_0izb6uZGDHybfjkQcLuGhF3kE35c7n52Br4aCOvAY_bvU1NnlHKAAxHwL2ah4nVMatEfaz_yUHQl212851uFCcwGMFcU6AGjYsMvNhqkUVwDnokM_NikXn9zk0q1cUjpp",
                      "https://www.zooplus.it/magazine/wp-content/uploads/2020/07/katze-liegt-im-gras-sommer-768x512.jpeg"
                    ],
    "audio_urls":   [
                      "https://www.youtube.com/watch?v=ozYjakb_py4",
                      "https://www.youtube.com/watch?v=R2WPjchkwK0",
                      "https://www.youtube.com/watch?v=jrkD8gvgz6o"
                    ],
    "sticker_ids":  [
                      "CAACAgIAAxkBAAEB05VgFHYx0A2Jzd57coTw7erGC971MQACoAMAAv7T1hHwwC8pfOSTax4E",
                      "CAACAgIAAxkBAAEB05dgFHZBmJ3qGZn3dCkpcqV_4fP0HgACpgMAAv7T1hG502iCGwYtJR4E",
                      "CAACAgIAAxkBAAEB05lgFHZSRJBvdD8V5aoCxawjCQm_NAACqgADtzxoB9vlRME86ErLHgQ",
                      "CAACAgIAAxkBAAEB051gFHaFaZQr9fWDQYwSOan6wiVOAAOhAwAC_tPWEaSCHFK19S0XHgQ",
                      "CAACAgIAAxkBAAEB059gFHaZq6rIdCWEaMdhWb2rd0wqZAACTAEAAnsS3wTlwPMrBFTtHx4E",
                      "CAACAgIAAxkBAAEB06FgFHanuRldas3idT2vrFiPfdc2LAACVgEAAnsS3wQVENKdf_29UB4E",
                      "CAACAgIAAxkBAAEB06NgFHa3L4S8rtUudM23fvchuVUnugACYwEAAnsS3wSyj0k3tD6_Lh4E",
                      "CAACAgIAAxkBAAEB06VgFHbKtNNG4iMrpr35bvMrQ0_pEAAChAEAAnsS3wSsnCd19xBiax4E",
                      "CAACAgIAAxkBAAEB06dgFHbeeTaNuLJwTVWBsnv8SZjjiAACawEAAnsS3wQit7hDQo3mRx4E",
                      "CAACAgIAAxkBAAEB06lgFHbsfvA1fGg40Yc62zQT3gvmeQACcQEAAnsS3wTFgwQchxDbuR4E",
                      "CAACAgIAAxkBAAEB06tgFHcMtg9ktbDuE7HhSMRsNVAN0AACTgEAAnsS3wRX_9e94fZLuR4E",
                      "CAACAgIAAxkBAAEB061gFHcewEgxjvLS0A5_5QnPcDUCCAACaQEAAnsS3wTxkBmtETvWIx4E",
                      "CAACAgIAAxkBAAEB069gFHcnBcH-Hwmp4oEnpIEw5iuAiwAChgEAAnsS3wTgi9JuobpQER4E"
                    ]
  }

  def start!(*args)
    @chat_bot.update!(enabled: true)
    respond_with :message, text: 'Enabled'
  end

  def message(message)
    #return unless @user.username.eql?('loyalistscfa')
    bot.delete_message(chat_id: chat['id'], message_id: message['message_id'])
    #send_generic_log(chat, message)
    
    if !message.text.nil? && message['text'].include?('http') || !message['video'].nil?
      respond_with(chat_id: chat['id'], text: get_url('ambient_urls'))
    end

    if !message['photo'].blank?
      respond_with(chat_id: chat['id'], text: get_url('photo_urls'))
    end

    if !message['voice'].nil? || !message['video_note'].nil?
      respond_with(chat_id: chat['id'], text: get_url('audio_urls'))
    end

    unless message['sticker'].nil?
      respond_with(chat_id: chat['id'], sticker: get_url('sticker_ids'))
    end

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

