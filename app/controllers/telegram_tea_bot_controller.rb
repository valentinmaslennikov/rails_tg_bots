
class TelegramTeaBotController < Telegram::Bot::UpdatesController
  # use callbacks like in any other controllers
  # around_action :with_locale

  # Every update can have one of: message, inline_query, chosen_inline_result,
  # callback_query, etc.
  # Define method with same name to respond to this updates.
  def message(message)
    # message can be also accessed via instance method
    message == self.payload # truegit push heroku master
    name = message['text'].scan(/чай:(.*)/i)&.last&.first&.strip if message['text'].present?
    review = message['text'].scan(/отзыв:(.*)/im)&.last&.first&.strip if message['text'].present?
    TeaReview.create!(name: name, review: review) if name.present? && review.present?
  end

  # This basic methods receives commonly used params:
  #
  #   message(payload)
  #   inline_query(query, offset)
  #   chosen_inline_result(result_id, query)
  #   callback_query(data)

  # Define public methods ending with `!` to handle commands.
  # Command arguments will be parsed and passed to the method.
  # Be sure to use splat args and default values to not get errors when
  # someone passed more or less arguments in the message.
  def start!(data = nil, *)
    # do_smth_with(data)

    # There are `chat` & `from` shortcut methods.
    # For callback queries `chat` if taken from `message` when it's available.
    response = from ? "Hello #{from['username']}!" : 'Hi there!'
    # There is `respond_with` helper to set `chat_id` from received message:
    respond_with :message, text: response
    # `reply_with` also sets `reply_to_message_id`:
    # reply_with :photo, photo: File.open('party.jpg')
  end

  private

  def with_locale(&block)
    I18n.with_locale(locale_for_update, &block)
  end

  def locale_for_update
    if from
      # locale for user
    elsif chat
      # locale for chat
    end
  end
end