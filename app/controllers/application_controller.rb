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
  
  def update_recommendations(movie_id, rating_value)
    newly_rated_movie_cluster = Movie.unit_cluster(Movie.find(movie_id), rating_value)

    newly_rated_movie_cluster.each do |new_movie|
      current_user.recommendations << Recommendation.create(movie_id: new_movie.id, user_id: current_user.id)
    end

    current_user.recommendations = current_user.recommendations.sample(50)
  end 

end
