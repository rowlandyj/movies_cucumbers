class RatingsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_ratings!
  
  def index
    @movies = get_fifty
  end

  def create
    params[:rating_value] = params[:rating_value].to_i
    params[:movie_id] = params[:movie_id].to_i
    rating = Rating.new(rating_value: params[:rating_value], movie_id: params[:movie_id], user_id: current_user.id)

    if rating.save
      # update_recommendations(params[:movie_id], params[:rating_value])
      UpdateRecsWorker.perform_async(params[:movie_id], params[:rating_value], current_user.id)
      render json: rating
    else
      # flash[:notice] = "You aleady rated this movie.  Check 'My Ratings'."
      # format.html { render action: "index"}
      render json: rating.errors
    end
  end

  def new
    rating = Rating.new
  end

  def update

    puts '*'*80
    puts "Params: #{params}"
    rating = Rating.find(params[:id])
    rating.rating_value = params[:rating_value]

    if rating.save
      # update_recommendations(rating.movie_id, rating.rating_value)
      UpdateRecsWorker.perform_async(params[:movie_id], params[:rating_value], current_user.id)
      render json: rating 
    else
      #show error message
      flash[:notice] = "Your ratings did not update."
      render json: rating.errors 
    end
    
  end
  
  def destroy
  end

  def search
    result = Pose.search "#{params[:query]}", [Movie, Actor, Director], limit: 20
    query_match = params[:query].downcase
    result[Actor].each do |actor|
      if actor.name.downcase == query_match
        @actor_movies = actor.movies
      end
    end

    result[Director].each do |director|
      if director.name.downcase == query_match
        @director_movies = director.movies
      end
    end

    @movies = result[Movie]
    # @ratings = current_user.ratings
    # @rating_values = {}
    # @rating_values = current_user.ratings.each do |rating|
    #   @rating_values[rating.movie_id] = rating.rating_value 
    # end

  end
end   

