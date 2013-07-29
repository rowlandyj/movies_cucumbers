class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  # before_filter :require_login

  # private

  # def require_login
  #   unless current_user
  #     redirect_to new_user_session_path
  #   end
  # end

  def get_fifty
    movies = []
    until movies.length == 51 
      random_number = Random.rand(1..Movie.count)
      movie = Movie.find(random_number)
      movies << movie unless movies.include? movie
      # movies.delete_if do |movie|
      #   Rating.where(user_id: current_user.id).pluck(:movie_id).include? movie.id
      # end
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

  
  def update_recommendations(movie_id, rating_value)
    newly_rated_movie_cluster = Movie.unit_cluster(Movie.find(movie_id), rating_value, current_user)
    puts "Cluster Length: #{newly_rated_movie_cluster.length}"
    newly_rated_movie_cluster.each do |new_movie|
      current_user.recommendations << Recommendation.create(movie_id: new_movie.id, user_id: current_user.id)
    end
    puts "Current User Recs: #{current_user.recommendations.length}"
    current_user.recommendations = current_user.recommendations.sample(50)
    puts "Current User Recs Post Sampe: #{current_user.recommendations.length}"
  end 

end
