class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  def get_fifty
    movies = []
    until movies.length == 52 
      random_number = Random.rand(1..Movie.count)
      movie = Movie.where(:id => random_number).first
      if !movie.nil?
        movies << movie unless movies.include? movie
      end
    end
    remove_duplicates(movies)
    movies
  end

  def remove_duplicates(movies)
    movies.delete_if do |movie|
      Rating.where(user_id: current_user.id).pluck(:movie_id).include? movie.id
    end
    movies
  end

  def get_ratings!
    @ratings = current_user.ratings
    @ratings_movie_ids = @ratings.pluck(:movie_id)
    @rating_values = {}
    current_user.ratings.each do |rating|
      @rating_values[rating.movie_id] = rating.rating_value 
    end
  end

end
