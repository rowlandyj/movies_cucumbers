class UpdateRecsWorker
  include Sidekiq::Worker
  include RecommendationSystem

  def perform(movie_id, rating_value, id)
    current_user = User.where(:id => id).includes(:ratings => :movie, :recommendations => :movie).first
    update_recommendations(movie_id, rating_value, current_user)
  end

end
