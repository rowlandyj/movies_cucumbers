class RatingsController < ApplicationController
  before_filter :authenticate_user!
  def index
    @movies = get_fifty
  end

  def create
    
    params[:rating_value] = params[:rating_value].to_i
    params[:movie_id] = params[:movie_id].to_i
    rating = Rating.new(rating_value: params[:rating_value], movie_id: params[:movie_id], user_id: current_user.id)

    respond_to do |format|
      if rating.save
        # update_recommendations(params[:movie_id], params[:rating_value])
        UpdateRecsWorker.perform_async(params[:movie_id], params[:rating_value], current_user.id)
        format.json { render json: rating }
        format.html { redirect_to request.referer }
      else
        # flash[:notice] = "You aleady rated this movie.  Check 'My Ratings'."
        # format.html { render action: "index"}
        format.json { render json: rating.errors }
        format.html { redirect_to request.referer }
      end
    end
  end

  def new
    rating = Rating.new
  end

  def update

    rating = Rating.find(params[:id])
    rating.rating_value = params[:rating_value]
    
    respond_to do |format|

      if rating.save
        # update_recommendations(rating.movie_id, rating.rating_value)
        UpdateRecsWorker.perform_async(params[:movie_id], params[:rating_value], current_user.id)
        format.json { render json: rating }
        format.html { redirect_to request.referer }
      else
        #show error message
        flash[:notice] = "Your ratings did not update."
        format.json { render json: rating.errors }
        format.html { redirect_to request.referer }
      end
    end
    
  end
  
  def destroy
  end

  def search
    @result = Pose.search "#{params[:query]}", [Movie]
  end
end   

