
class TelegramRustController < Telegram::Bot::UpdatesController
  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::NumberHelper

  before_action :set_chat_id, :check_jail, :set_current_user
  before_action :check_enabled, except: [:start!]
  before_action :check_banned, except: :message

  PT = %w[I\ walked. I\ could\ do\ nothing\ but\ walk. And\ then,\ I\ saw\ me\ walking\ in\ front\ of\ myself.
          But\ it\ wasn't\ really\ me. Watch\ out. The\ gap\ in\ the\ door...\ it's\ a\ separate\ reality.
          The\ only\ me\ is\ me. Are\ you\ sure\ the\ only\ you\ is\ you? You've\ been\ chosen.
          You\ got\ fired,\ so\ you\ drowned\ your\ sorrows\ in\ booze.
          She\ had\ to\ get\ a\ part-time\ job\ working\ a\ grocery\ store\ cash\ register.
          Only\ reason\ she\ could\ earn\ a\ wage\ at\ all\ is\ the\ manager\ liked\ how\ she\ looked\ in\ a\ skirt.
          You\ remember,\ right? Exactly\ ten\ months\ back. 204863 Don't\ touch\ that\ dial\ now,\ we're\ just\ getting\ started.
          You\ can't\ trust\ the\ tap\ water. Look\ behind\ you. I\ said,\ look\ behind\ you. There's\ a\ monster\ inside\ of\ me
          After\ killing\ his\ family,\ the\ father\ hung\ himself\ with\ a\ garden\ hose\ they\ had\ in\ the\ garage.
          Close\ your\ eyes. Let\ your\ ears\ listen\ to\ the\ radio. Do\ you\ hear\ my\ voice?
          Can\ you\ hear\ your\ own\ soul's\ scream? Let\ us\ choose. My\ voice\ that\ tells\ the\ future.
          Or\ your\ tortured\ mind. Well,\ what\ do\ you\ choose? You\ can\ choose. Your\ life,\ your\ future.
          Wise\ as\ you\ are\ you\ might\ already\ have\ discovered\ it.
          Yes,\ the\ radio\ drama\ from\ 75\ years\ ago\ was\ true.
          They\ are\ here\ on\ our\ earth\ and\ they\ monitor\ and\ see\ all. Don't\ trust\ anyone.
          Don't\ trust\ the\ police. They\ are\ already\ controlled\ by\ them.
          That's\ the\ way\ it\ has\ been\ for\ 75\ years\ now. Only\ our\ best\ will\ prevail. You\ have\ a\ right.
          A\ right\ to\ become\ one\ of\ us. So,\ welcome\ to\ our\ world. Very\ soon\ the\ gates\ to\ a\ new\ dimension\ will\ open.
          204863.]
  def start!(*args)
    @chat.update!(enabled: true)
    #respond_with :message, text: phrases_from_file(TextDirectory.find_by_name('stalker-bandits-set').text)
    respond_with :message, text: 'Started'
  end

  def message(message)
    begin
    if @chat.purge_mod?
      bot.delete_message(chat_id: chat['id'], message_id: message['message_id'])
      respond_with :message, text: PT.sample
      return
    end
    if false#@user.username!='loyalistscfa' && message['text'] && message['text'].match(/(пид[оа]р|сука|сучара|бля[тд]?ь?|[хx]уй|[хx]у[ёе]|[хx]ул[ие]|пизд|за[её]ба|[её]ба[нт]|хуи[лщ][ае]|хyй)/i)
      bot.delete_message(chat_id: chat['id'], message_id: message['message_id'])
      Offence.create!(text: message['text'], username: message['from']['username'])
      respond_with :message, text: 'https://fathomless-beach-05289.herokuapp.com/leha228.jpg'
    end
    rescue Exception => e
      puts e
    end
  end

  def i_will_be_coming_back!
    if @user.username.eql?('loyalistscfa')
      @chat.update!(purge_mod: false)
    else
      respond_with :message, text: PT.sample
    end
  end

  def ban!(*args)
    if @user.username.eql?('loyalistscfa')
      User.find_by_username(args.first.to_s).update!(banned: true)
    end
  end

  def unban!(*args)
    if @user.username.eql?('loyalistscfa')
      User.find_by_username(args.first.to_s).update!(banned: false)
    end
  end

  def he_goes_and_kills_us_all!
    @chat.update!(purge_mod: true)
  end

  def stop!(*args)
    if @chat.purge_mod?
      if @user.username.eql?('loyalistscfa')
      respond_with :message, text: 'Stopped'
      @chat.update!(enabled: false)
      else
      respond_with :message, text: 'Forgive me, Lisa'
      end
    else
      @chat.update!(enabled: false)
    end
  end

  def cyberpunk!(*args)
    dist = distance_of_time_in_words_to_now(Time.new(2020,12,10,2,0,0,Time.zone), include_seconds: true)
    if args[0].eql?('hours')
      dist = distance_of_time_in_words_to_now(Time.new(2020,12,10,2,0,0,Time.zone), include_seconds: true, accumulate_on: :hours)
    elsif args[0].eql?('seconds')
      dist = distance_of_time_in_words_to_now(Time.new(2020,12,10,2,0,0,Time.zone), include_seconds: true, accumulate_on: :seconds)
    elsif args[0].eql?('minutes')
      dist = distance_of_time_in_words_to_now(Time.new(2020,12,10,2,0,0,Time.zone), include_seconds: true, accumulate_on: :minutes)
    end
    respond_with :message, text:  "#{dist} left"
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

  def check_banned
    throw(:abort) if @user.banned?
  end

  def check_enabled
    throw(:abort) unless @chat.enabled?
  end

  def check_jail
    begin
      message = self.payload
      prisoner = PrisonerRepo.find_by(username: @user.username)
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