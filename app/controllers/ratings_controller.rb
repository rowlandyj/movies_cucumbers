class RatingsController < ApplicationController
  before_filter :authenticate_user!
  def index
    @movies = Movie.find(:all).sample(50)

  end

  def create
    rating = Rating.new(rating_value: params[:rating_value], movie_id: params[:movie_id], user_id: current_user.id)
    if rating.save
      update_recommendations
      redirect_to ratings_path
    else
      #show error message
      redirect_to new_user_rating_path
    end
  end

  def new
    rating = Rating.new
  end
  def edit
  end
  def show
  end
  def update
  end
  def destroy
  end
end   

