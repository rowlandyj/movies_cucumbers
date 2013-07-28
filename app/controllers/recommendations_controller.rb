class RecommendationsController < ApplicationController
  before_filter :authenticate_user!

  def index

    @recommendations = current_user.recommendations
    puts '*'*150
    puts "Recs Pre Delete: #{@recommendations.length}"
    @recommendations.delete_if do |rec|
      current_user.ratings.pluck(:movie_id).include? rec.movie_id
    end

    puts "Recs post delete_if: #{@recommendations.length}"
    @recommendations.shuffle!
  end

  def create
  end

  def new
    @recommendation = Recommendation.new
  end
  
end
