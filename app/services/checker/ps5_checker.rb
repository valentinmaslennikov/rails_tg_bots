require 'telegram/bot'

class Checker::Ps5Checker < BaseService
  attr_accessor :params

  def initialize(params = {})
    @params = params
  end

  LINKS_DIGITAL = %w(https://www.mvideo.ru/products/igrovaya-konsol-sony-playstation-5-40073270?cityId=CityCZ_2030 https://www.mvideo.ru/products/igrovaya-konsol-sony-playstation-5-digital-edition-40074203?cityId=CityCZ_2030)
  LINKS_DISK    = %w(https://www.mvideo.ru/products/igrovaya-konsol-sony-playstation-5-40073270?cityId=CityCZ_2030 https://www.mvideo.ru/products/igrovaya-konsol-sony-playstation-5-digital-edition-40074203?cityId=CityCZ_2030)

  def call
    LINKS_DIGITAL.map do |link|
      response = Faraday.get(link)
      unless response.body.force_encoding(Encoding::UTF_8) =~ /Товар распродан/
        @chat.pluck(:system_id).map { |i| Telegram.bots[:upgrade].send_message(chat_id: i, text: "Цифровая версия пс5 доступна для покупки #{link}") }
      end
    end
    LINKS_DISK.map do |link|
      response = Faraday.get(link)
      unless response.body.force_encoding(Encoding::UTF_8) =~ /Товар распродан/
        @chat.pluck(:system_id).map { |i| Telegram.bots[:upgrade].send_message(chat_id: i, text: "Дисковая версия пс5 доступна для покупки #{link}") }
      else
        @chat.pluck(:system_id).map { |i| Telegram.bots[:upgrade].send_message(chat_id: i, text: "Дисковая версия пс5 недоступна для покупки #{link}") }
      end
    end
  end
end