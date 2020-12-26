class TwilioTextMessenger
  attr_reader :message

  def initialize(message)
    @message = message
  end

  def call
    client = Twilio::REST::Client.new
    client.messages.create({
                             from: ENV.fetch("TWILIO_ACCOUNT_PHONE_FROM", ""),
                             to:   '',
                             body: message
                           })
  end
end
