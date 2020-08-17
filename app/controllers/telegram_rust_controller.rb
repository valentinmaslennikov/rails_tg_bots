
class TelegramRustController < Telegram::Bot::UpdatesController
  VOVELS = %w(а о э и у ы е ё ю я)
  HASH_TO_REPLACE = {'а' => 'я',
                     'о' => 'ё',
                     'э' => 'э',
                     'и' => 'и',
                     'у' => 'ю',
                     'ы' => 'ы',
                     'е' => 'е',
                     'ё' => 'ё',
                     'ю' => 'ю',
                     'я' => 'я'}

  PAUK_SENTENCES = %w(АД АДОВО АЦКИ Алё\ КАССА!
                    АНАЛОГОВЫЙ\ ПРОДУКТ АЦКИЙ\ АБОРТ
                    БАТЛ БАТОНЫ БЕЗАЛКОГОЛЬНАЯ\ ДИСКОТЕКА БЕЗ\ ДЕРЬМА
                    БЕС\ противоречия БЛЯД БОЛТ БРИТОГОЛОВЫЕ\ ИДУТ БЫКОВАТЬ
                    ВАСЮКИ ВОбЩЕМТА ТАЩЕМТА
                    ВЕДЬМа\ из\ БЛЭР В\ ГОЛОВУ ГУРЗУФ ГИТЛЕР\ ШИШКИН
                    ГОЛАЯ\ МАРИНА ГОРи\ В\ АДУ ДИКО ДИЧАЙШЕ ДИМЕДРОЛЬНОЕ\ ПИВО
                    ДОРЕВОЛЮЦИОННЫЙ\ СТИЛЬ ДЬЯВОЛЬСКИЙ\ КОНТРАКТ ЕЛЬЦИН\ где\ мои\ ДЕНЬГИ?!)

  def message(message)
    begin
      chat = Chat.find_or_create_by(system_id: message['chat']['id'])
      #puts message.methods - Object.methods
      prisoner = Prisoner.find_by_username(message['from']['username'])
      if prisoner.present? && message['text'] != ''
        #bot.api.delete_message(chat_id: message.chat.id, message_id: message.message_id)
        #bot.api.forwardMessage(chat_id: message.chat.id, from_chat_id: message.chat.id, message_id: message.message_id)
        respond_with :message, text: "тов.#{prisoner.username} доложил что:\n\"#{message['text']}\""
        respond_with :message, text: phrases_from_file(TextDirectory.find_by_name('riot').text)
        (prisoner.term - 1).eql?(0) ? prisoner.destroy : prisoner.update!(term: prisoner.term - 1)
        return
      end
    rescue StandardError => e
      puts e
      puts e.backtrace
    end
    case message['text']
    when /горшочек вари/
      chat.update!(enabled: true)
    when /горшочек не вари/
      puts chat
      chat.update!(enabled: false)
    end
    return nil unless chat.enabled?
    sleep(1)
    case message['text']&.downcase
      #when /отправьте черный воронок за\s(\w*)/
      #when /верните в народ\s(\w*)/
    when /киберпанк/
      respond_with :message, text:  "осталось #{(DateTime.new(2020,11,19) - DateTime.now).to_i } дней"
    when /\/punish\s(\w*)\s(\d)/
      Prisoner.create(username: $1, term: $2)
      respond_with :message, text: 'Братва, затаились. Белые идут...'
    when /фото\s(.*)/
      begin
      items = GoogleCustomSearchApi.search($1, searchType: "image")
      items1 = items["items"]
      puts items
      puts items1
      text = items1.sample["link"]

      puts "term = '#{$1}' items - #{items.size}"
      rescue
      end
      respond_with :message, text: text
    when /спали/
      porn_list = porn
      puts porn_list
      porn_list.first(2).each do |p|
        respond_with :message, text: p
      end
    when /(вид(ео|яху|яха|яшка|яшки|яшку|ос(ом|ы|е|ик|ики)?))\s?(про|с|от)?\s("?[A-Za-z0-9_А-Яа-я,ёЁ'!?\s-]*"?)/
      respond_with :message, text: "nic nie jest litością dla drogiej osoby #{youtube_link($5)}"
    when /коммунизм/
      respond_with :message, text: 'https://www.youtube.com/watch?v=HtFG_UEPjds'

    when /родину любить|патриотическое/
      respond_with :message, text: 'https://www.youtube.com/watch?v=r29k_T_o9To'
    when /капиталист/
      respond_with :message, text: 'Ублюдок, мать твою, а ну иди сюда, говно собачье!'\
                                                           ' Что, решил ко мне лезть?! Ты, засранец вонючий, '\
                                                           'мать твою, а? Ну, иди сюда,﻿ попробуй меня трахнуть,'\
                                                           ' я тебя сам трахну, ублюдок, онанист чертов, будь ты'\
                                                           ' проклят! Иди, идиот, трахать тебя и всю твою семью,'\
                                                           ' говно собачье, жлоб вонючий, дерьмо, сука, падла!'\
                                                           ' Иди сюда, мерзавец, негодяй, гад, иди сюда, ты, говно, ЖОПА!'
    else
      begin
        #case rand(2)
        #bot.api.setChatPhoto(chat_id: -148142385, photo: Faraday::UploadIO.new('/home/loyalist/Изображения/70ed091ae52cca14dd9d437c9b8784a7.jpg', 'image/jpeg'))
        #when 1
        #bot.api.send_message(chat_id: message.chat.id, text: huz(message.text))
        #else
        #bot.api.send_message(chat_id: message.chat.id, text: PAUK_SENTENCES.map { |i| i.downcase }.sample)
        #end
        respond_with :message, text: phrases_from_file(TextDirectory.find_by_name('stalker-bandits-set').text)
      rescue
        respond_with :message, text: 'ты там охуел чтоли сука?'
      end
    end
  end

  private

  def get_rand(size = 5)
    charset = %w{0 1 2 3 4 6 7 9 A B C D E F G H I J K L M O P Q R S T U V W X Y Z}
    (0...size).map { charset.to_a[rand(charset.size)] }.join
  end

  def redtube_tag
    url = 'https://api.redtube.com/?data=redtube.Tags.getTagList&output=json'
    res = JSON.parse(Faraday.get(URI.escape(url)).body)
    res['tags'].sample.dig('tag', 'tag_name')
  end

  def porn
    url = "https://api.redtube.com/?data=redtube.Videos.searchVideos&output=json&tags[]=#{redtube_tag}"
    res = JSON.parse(Faraday.get(URI.escape(url)).body)
    res.dig('videos').map { |i| i.dig('video', 'url') }
  end

  def youtube_link(text = nil)
    count = 50
    random = text.nil? ? get_rand(3) : text

    urlData = "https://www.googleapis.com/youtube/v3/search?key=#{Rails.application.credentials[:YOUTUBE_API_TOKEN]}&maxResults=#{count}&part=snippet&type=video&q=#{random}"
    res = JSON.parse(Faraday.get(URI.escape(urlData)).body)
    rand_video_id = text.match(/"/) ? res['items'][0]['id']['videoId'] : res['items'].map { |i| i['id']['videoId'] }.sample
    rand_video_id.present? ? "https://www.youtube.com/watch?v=#{rand_video_id}" : 'хуй соси, такого там нет'
  end

  def phrases_from_file text
    text.split(/\n/).sample
  end

  def huz(message)
    last_word = message.gsub(/[^\p{L}\s\d]/, '-').scan(/[а-яА-Я]+$/)[0].split('')
    pre = last_word.each_with_object([]) { |i, acc| VOVELS.include?(i) ? (acc << i; break acc) : acc << i }.join()
    puts "pre = #{pre}"

    new_pre = pre.gsub(/#{VOVELS}$/, HASH_TO_REPLACE).scan(/#{VOVELS}/).join().prepend('ху')
    return 'ты че сука, выебываешься?' if last_word.join().eql?(pre)
    last_word.join().gsub(/^#{pre}/, new_pre)
  end
end