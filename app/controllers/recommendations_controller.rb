class RecommendationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_ratings!

  def index
    @recommendations = current_user.recommendations
    @recommendations.delete_if do |rec|
      current_user.ratings.pluck(:movie_id).include? rec.movie_id
    end
    @recommendations.shuffle!
  end
  
end
