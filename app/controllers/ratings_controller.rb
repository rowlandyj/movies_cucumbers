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
      UpdateRecsWorker.perform_async(params[:movie_id], params[:rating_value], current_user.id)
      render json: rating
    else
      render json: rating.errors
    end
  end

  def new
    rating = Rating.new
  end

  def update
    rating = Rating.find(params[:id])
    rating.rating_value = params[:rating_value]

    if rating.save
      UpdateRecsWorker.perform_async(params[:movie_id], params[:rating_value], current_user.id)
      render json: rating 
    else
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
  end
end   

