class OffencesController < ApplicationController
  def index
    @offences = Offence.order(created_at: :desc)
  end
end
