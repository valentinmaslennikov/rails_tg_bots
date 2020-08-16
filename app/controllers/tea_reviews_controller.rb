class TeaReviewsController < ApplicationController
  def index
    @tea_reviews = TeaReview.all
  end
end
