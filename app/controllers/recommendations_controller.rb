class RecommendationsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @recommendations=current_user.recommendations
    @recommendations.delete_if do |rec|
      current_user.ratings.pluck(:movie_id).include? rec.movie_id
    end
  end

  def create
  end

  def new
    @recommendation = Recommendation.new
  end
  
end