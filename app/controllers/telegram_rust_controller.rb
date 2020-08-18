
class TelegramRustController < Telegram::Bot::UpdatesController
  before_action :set_chat_id

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
    check_jail(message)

    return nil unless  @chat.enabled?
    sleep(1)

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

  def горшочек_вари!(**args)
    @chat.update!(enabled: true)
  end

  def горшочек_не_вари!(**args)
    @chat.update!(enabled: false)
  end

  def киберпанк!(**args)
    respond_with :message, text:  "осталось #{(DateTime.new(2020,11,19) - DateTime.now).to_i } дней"
  end

  def видео!(**args)
    respond_with :message, text: "nic nie jest litością dla drogiej osoby #{youtube_link(args.to_s)}"
  end

  def porno!(**args)
    porn_list = porn
    puts porn_list
    porn_list.first(2).each do |p|
      respond_with :message, text: p
    end
  end

  def mercy!(**args)
    Prisoner.destroy_all
  end

  def punish!(name = nil, term = nil, **args)
    if name.present? && term.present?
      Prisoner.find_or_create_by!(username: name) do |t|
        t.term = term
      end
      respond_with :message, text: 'Братва, затаились. Белые идут...'
    end
  end

  def фото!(**args)
    begin
      puts args
      args = args.to_s
      items = GoogleCustomSearchApi.search(args.to_s, searchType: "image")
      items1 = items["items"]
      puts items
      puts items1
      text = items1.sample["link"]

      puts "term = '#{args}' items - #{items.size}"
      respond_with :message, text: text
    rescue
    end
  end

  private

  def check_jail(message)
    begin
      prisoner = PrisonerRepo.find_by(username: message['from']['username'])
      if prisoner.present? && message['text'] != ''
        respond_with :message, text: "тов.#{prisoner.username} доложил что:\n\"#{message['text']}\""
        if (prisoner.term - 1).eql?(0)
          respond_with :message, text: phrases_from_file(TextDirectory.find_by_name('riot').text)
          prisoner.destroy
        else
          prisoner.update!(term: prisoner.term - 1)
        end
        return
      end
    rescue StandardError => e
      puts e
      puts e.backtrace
    end
  end

  def set_chat_id
    @chat = Chat.find_or_create_by(system_id: chat['id'])
  end

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