class RecommendationsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @recommendations = current_user.recommendations
    @recommendations.delete_if do |movie|
      Rating.where(user_id: current_user.id).pluck(:movie_id).include? movie.id
    end
  end

  def create
  end

  def new
    @recommendation = Recommendation.new
  end
  
end
