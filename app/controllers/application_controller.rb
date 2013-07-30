class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  def get_fifty
    movies = []
    until movies.length == 52 
      random_number = Random.rand(1..Movie.count)
      movie = Movie.find(random_number)
      movies << movie unless movies.include? movie
      remove_duplicates(movies)
    end
    movies
  end

  def remove_duplicates(movies)
    movies.delete_if do |movie|
      Rating.where(user_id: current_user.id).pluck(:movie_id).include? movie.id
    end
    movies
  end

end
