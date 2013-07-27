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
  
  def update_recommendations
    current_user.recommendations.delete_all
    all_users_ratings = current_user.ratings    
    recommended_movie_cluster = []
      all_users_ratings.each do |movie|
        recommended_movie_cluster << Movie.unit_cluster(Movie.find(movie.id),movie.rating_value)
      end
    recommended_movie_cluster.flatten!

      recommended_movie_cluster.sample(50).each do |recommended_movies|
        Recommendation.create(movie_id: recommended_movies.id, user_id: current_user.id)
      end
    end 

end
