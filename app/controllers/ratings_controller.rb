class RatingsController < ApplicationController
  before_filter :authenticate_user!
  def index
    @movies = Movie.find(:all).sample(50)
    @movies.delete_if do |movie|
      Rating.where(user_id: current_user.id).pluck(:movie_id).include? movie.id
    end
  end

  def create
    rating = Rating.new(rating_value: params[:rating_value], movie_id: params[:movie_id], user_id: current_user.id)
    if rating.save
      update_recommendations
      redirect_to request.referer
    else
      flash[:notice] = "You aleady rated this movie.  Check 'My Ratings'."
      redirect_to request.referer
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

    rating = Rating.find(params[:id])
    rating.rating_value = params[:rating_value]
    if rating.save
      update_recommendations
      redirect_to request.referer
    else
      #show error message
      flash[:notice] = "Your ratings did not update."
      redirect_to request.referer
    end
    
  end
  def destroy
  end
end   

