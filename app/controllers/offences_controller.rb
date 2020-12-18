class OffencesController < ApplicationController
  def index
    @offences = Offence.all
  end
end
