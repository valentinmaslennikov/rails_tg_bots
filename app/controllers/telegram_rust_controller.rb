
class TelegramRustController < Telegram::Bot::UpdatesController
  before_action :set_chat_id, :check_jail, :he_goes_and_kills_us_all, :message
  before_action :check_enabled, except: [:start!]

  PT = %w[I\ walked. I\ could\ do\ nothing\ but\ walk. And\ then,\ I\ saw\ me\ walking\ in\ front\ of\ myself.
          But\ it\ wasn't\ really\ me. Watch\ out. The\ gap\ in\ the\ door...\ it's\ a\ separate\ reality.
          The\ only\ me\ is\ me. Are\ you\ sure\ the\ only\ you\ is\ you? You've\ been\ chosen.
          You\ got\ fired,\ so\ you\ drowned\ your\ sorrows\ in\ booze.
          She\ had\ to\ get\ a\ part-time\ job\ working\ a\ grocery\ store\ cash\ register.
          Only\ reason\ she\ could\ earn\ a\ wage\ at\ all\ is\ the\ manager\ liked\ how\ she\ looked\ in\ a\ skirt.
          You\ remember,\ right? Exactly\ ten\ months\ back. 204863 Don't\ touch\ that\ dial\ now,\ we're\ just\ getting\ started.
          You\ can't\ trust\ the\ tap\ water. Look\ behind\ you. I\ said,\ look\ behind\ you. There's\ a\ monster\ inside\ of\ me
          After\ killing\ his\ family,\ the\ father\ hung\ himself\ with\ a\ garden\ hose\ they\ had\ in\ the\ garage.]
  def start!(*args)
    @chat.update!(enabled: true)
    #respond_with :message, text: phrases_from_file(TextDirectory.find_by_name('stalker-bandits-set').text)
    respond_with :message, text: 'Started'
  end

  def message(message)
    if @chat.purge_mod?
      bot.delete_message(chat_id: chat['id'], message_id: message['message_id'])
      respond_with :message, text: PT.sample
    end
    if from['username']!='loyalistscfa' && message['text'] && message['text'].match(/(\s+|^)[пПnрРp]?[3ЗзВBвПnпрРpPАaAаОoO0о]?[сСcCиИuUОoO0оАaAаыЫуУyтТT]?[Ппn][иИuUeEеЕ][зЗ3][ДдDd]\w*[\?\,\.\;\-]*|(\s+|^)[рРpPпПn]?[рРpPоОoO0аАaAзЗ3]?[оОoO0иИuUаАaAcCсСзЗ3тТTуУy]?[XxХх][уУy][йЙеЕeEeяЯ9юЮ]\w*[\?\,\.\;\-]*|(\s+|^)[бпПnБ6][лЛ][яЯ9]([дтДТDT]\w*)?[\?\,\.\;\-]*|(\s+|^)(([зЗоОoO03]?[вВнН]?[ыЫаА]?[аАaAтТT]?[ъЪ]?)|(\w+[оОOo0еЕeE]))?[еЕeEиИuUёЁ][бБ6пП]([аАaAиИuUуУy]\w*)?[\?\,\.\;\-]*/)
      bot.delete_message(chat_id: chat['id'], message_id: message['message_id'])
      Offence.create!(text: message['text'], username: message['from']['username'])
      respond_with :message, text: 'https://pngimg.com/uploads/denied/denied_PNG4.png'
    end
  end

  def i_will_be_coming_back!
    if from['username']!='loyalistscfa'
      @chat.update!(purge_mod: false)
    else
      respond_with :message, text: PT.sample
    end
  end

  def he_goes_and_kills_us_all!
    @chat.update!(purge_mod: true)
  end

  def stop!(*args)
    if from['username']!='loyalistscfa'
      respond_with :message, text: 'Stopped'
      @chat.update!(enabled: false)
    else
      respond_with :message, text: 'Forgive me, Lisa'
    end
  end

  def cyberpunk!(*args)
    respond_with :message, text:  "#{(DateTime.new(2020,11,19) - DateTime.now).to_i } days left"
  end

  def youtube!(*args)
    respond_with :message, text: youtube_link(args)
  end

  def porno!(*args)
    porn_list = porn
    porn_list.first(2).each do |p|
      respond_with :message, text: p
    end
  end

  def mercy!(*args)
    Prisoner.destroy_all
  end

  def punish!(name = nil, term = nil, *args)
    if name.present? && term.present?
      Prisoner.find_or_create_by!(username: name) do |t|
        t.term = term
      end
      respond_with :message, text: 'Ready to forward'
    end
  end

  def photo!(*args)
    begin
      args = args.to_s
      items = GoogleCustomSearchApi.search(args.to_s, searchType: "image")
      items1 = items["items"]
      text = items1.sample["link"]
      respond_with :message, text: text
    rescue
    end
  end

  private

  def check_enabled
    throw(:abort) unless @chat.enabled?
  end

  def check_jail
    begin
      message = self.payload
      prisoner = PrisonerRepo.find_by(username: from['username'])
      if prisoner.present? && message['text'] != ''
        respond_with :message, text: "#{prisoner.username}:\n\"#{message['text']}\""
        if (prisoner.term - 1).eql?(0)
          #respond_with :message, text: phrases_from_file(TextDirectory.find_by_name('riot').text)
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

  def youtube_link(args = nil)
    count = 50
    straight = args.include?('!')
    text = (args - ['!']).join(' ')
    random = text.nil? ? get_rand(3) : text

    urlData = "https://www.googleapis.com/youtube/v3/search?key=#{Rails.application.credentials[:YOUTUBE_API_TOKEN]}&maxResults=#{count}&part=snippet&type=video&q=#{random}"
    res = JSON.parse(Faraday.get(URI.escape(urlData)).body)
    rand_video_id = straight ? res['items'][0]['id']['videoId'] : res['items'].map { |i| i['id']['videoId'] }.sample
    rand_video_id.present? ? "https://www.youtube.com/watch?v=#{rand_video_id}" : 'хуй соси, такого там нет'
  rescue Exception => e
    e
  end

  def phrases_from_file text
    text.split(/\n/).sample
  end

  def huz(message)
    last_word = message.gsub(/[^\p{L}\s\d]/, '-').scan(/[а-яА-Я]+$/)[0].split('')
    pre = last_word.each_with_object([]) { |i, acc| VOVELS.include?(i) ? (acc << i; break acc) : acc << i }.join()

    new_pre = pre.gsub(/#{VOVELS}$/, HASH_TO_REPLACE).scan(/#{VOVELS}/).join().prepend('ху')
    return 'ты че сука, выебываешься?' if last_word.join().eql?(pre)
    last_word.join().gsub(/^#{pre}/, new_pre)
  end
end