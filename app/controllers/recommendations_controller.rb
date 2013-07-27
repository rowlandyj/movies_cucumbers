class RecommendationsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @recommendations = current_user.recommendations
  end

  def create
  end

  def new
    @recommendation = Recommendation.new
  end
  
end
