class RecommendationsController < ApplicationController
  before_filter :authenticate_user!

  def index
 
  end

  def create
  end

  def new
    @recommendation = Recommendation.new
  end
  
end
