module ErrorHandleable
  extend ActiveSupport::Concern
  included do
    rescue_from Errors::NoGameInProgressError do |exception|
      respond_with :message, text: 'все обедают в музее поле чудес, и ты иди отсюда'
    end

    rescue_from Errors::WrongPlayer do |exception|
      respond_with :message, text: 'не выкрикивайте с места, дождитесь очереди!'
    end
  end
end
