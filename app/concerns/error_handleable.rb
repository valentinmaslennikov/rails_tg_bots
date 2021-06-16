module ErrorHandleable
  extend ActiveSupport::Concern
  included do
    rescue_from Errors::NoGameInProgressError, with: -> { respond_with :message, text: 'все обедают в музее поле чудес, и ты иди отсюда' }
    rescue_from Errors::WrongPlayer, with: -> { respond_with :message, text: 'не выкрикивайте с места, дождитесь очереди!' }
    rescue_from Errors::OtherUser, with: -> { respond_with :message, text: 'что за крики из зала? выведите его в коридор и расстреляйте его там нахуй!' }
  end
end
